/// VlsmCalculator
/// Variable Length Subnet Masking — pure calculation logic.
/// Allocates subnets from largest to smallest to minimize waste.

import '../models/vlan_model.dart';
import '../utils/ip_utils.dart';

class VlsmCalculator {
  VlsmCalculator._();

  /// Calculates VLSM allocation for a list of segments.
  ///
  /// [baseNetwork]  — e.g. '192.168.1.0'
  /// [basePrefix]   — e.g. 24
  /// [entries]      — list of VlsmEntry (name + required hosts)
  ///
  /// Returns ordered VlsmResult list (largest subnet first).
  /// Throws [ArgumentError] if the network is too small.
  static List<VlsmResult> calculate(
    String baseNetwork,
    int basePrefix,
    List<VlsmEntry> entries,
  ) {
    if (entries.isEmpty) throw ArgumentError('No entries provided');

    // ── Validate that baseNetwork is actually a network address ────────────
    final computedBase = IpUtils.networkAddress(baseNetwork, basePrefix);
    if (computedBase != baseNetwork.trim()) {
      throw ArgumentError(
        'La dirección $baseNetwork/$basePrefix es una IP de host, no de red.\n'
        '¿Quisiste decir $computedBase/$basePrefix?',
      );
    }

    // ── Sort by required hosts descending (largest first) ──────────────────
    final sorted = List<VlsmEntry>.from(entries)
      ..sort((a, b) => b.requiredHosts.compareTo(a.requiredHosts));

    // ── Verify total space fits ────────────────────────────────────────────
    final totalRequired = sorted.fold<int>(
        0, (sum, e) => sum + _requiredBlockSize(e.requiredHosts));
    final totalAvailable = IpUtils.totalAddresses(basePrefix);
    if (totalRequired > totalAvailable) {
      throw ArgumentError(
          'Not enough address space. Required: $totalRequired, Available: $totalAvailable');
    }

    // ── Allocate subnets sequentially ──────────────────────────────────────
    final results = <VlsmResult>[];
    String currentNetwork = IpUtils.networkAddress(baseNetwork, basePrefix);

    for (final entry in sorted) {
      final newPrefix = _neededPrefix(entry.requiredHosts);
      // Align current pointer to the new block boundary
      currentNetwork = _align(currentNetwork, newPrefix);

      final mask = IpUtils.prefixToMask(newPrefix);
      final first = IpUtils.firstHost(currentNetwork, newPrefix);
      final last = IpUtils.lastHost(currentNetwork, newPrefix);
      final broadcast = IpUtils.broadcastAddress(currentNetwork, newPrefix);
      final usable = IpUtils.usableHosts(newPrefix);

      results.add(VlsmResult(
        name: entry.name,
        requiredHosts: entry.requiredHosts,
        networkAddress: currentNetwork,
        subnetMask: mask,
        firstHost: first,
        lastHost: last,
        broadcastAddress: broadcast,
        usableHosts: usable,
        cidrPrefix: newPrefix,
      ));

      // Advance pointer past this subnet
      currentNetwork = IpUtils.nextNetwork(currentNetwork, newPrefix);
    }

    return results;
  }

  /// Returns the minimum CIDR prefix that accommodates [hosts] usable hosts.
  static int _neededPrefix(int hosts) {
    // Need at least hosts+2 addresses (network + broadcast)
    for (int prefix = 30; prefix >= 0; prefix--) {
      if (IpUtils.usableHosts(prefix) >= hosts) return prefix;
    }
    return 0;
  }

  /// Returns the block size (power of 2) for a given host count.
  static int _requiredBlockSize(int hosts) {
    final prefix = _neededPrefix(hosts);
    return IpUtils.totalAddresses(prefix);
  }

  /// Aligns an IP address to the next boundary for the given prefix.
  static String _align(String ip, int prefix) {
    final blockSize = IpUtils.totalAddresses(prefix);
    final ipInt = IpUtils.ipToInt(ip);
    // Round up to the next multiple of blockSize
    final aligned = ((ipInt + blockSize - 1) ~/ blockSize) * blockSize;
    return IpUtils.intToIp(aligned);
  }

  /// Builds a human-readable allocation table string.
  static String buildAllocationTable(List<VlsmResult> results) {
    final sb = StringBuffer();
    sb.writeln('VLSM Allocation Table');
    sb.writeln('=' * 60);
    sb.writeln(
        '${'Segment'.padRight(16)} ${'Network'.padRight(20)} ${'Mask'.padRight(16)} Hosts');
    sb.writeln('-' * 60);
    for (final r in results) {
      sb.writeln(
        '${r.name.padRight(16)} '
        '${r.networkAddress.padRight(18)}/${r.cidrPrefix} '
        '${r.subnetMask.padRight(16)} '
        '${r.usableHosts}',
      );
    }
    sb.writeln('=' * 60);
    return sb.toString();
  }

  /// Builds step-by-step explanation for VLSM.
  static List<String> buildExplanation(
    String baseNetwork,
    int basePrefix,
    List<VlsmResult> results, {
    bool isSpanish = true,
  }) {
    final steps = <String>[];
    if (isSpanish) {
      steps.add(
        '📋 Resumen VLSM\n'
        '   Red base       : $baseNetwork/$basePrefix\n'
        '   Total segmentos: ${results.length}\n\n'
        '   VLSM asigna subredes de distintos tamaños\n'
        '   desde un único bloque de direcciones.\n'
        '   Los segmentos se ordenan de mayor a menor\n'
        '   para minimizar el desperdicio de IPs.',
      );
      for (int i = 0; i < results.length; i++) {
        final r = results[i];
        steps.add(
          '📌 Paso ${i + 2} — Asignar "${r.name}"\n'
          '   Hosts requeridos : ${r.requiredHosts}\n'
          '   Prefijo necesario: /${r.cidrPrefix} '
          '(${r.usableHosts} hosts utilizables)\n'
          '   Red              : ${r.networkAddress}/${r.cidrPrefix}\n'
          '   Máscara          : ${r.subnetMask}\n'
          '   Rango            : ${r.firstHost} — ${r.lastHost}\n'
          '   Broadcast        : ${r.broadcastAddress}',
        );
      }
      steps.add(
        '✅ Asignación Completa\n'
        '   Los ${results.length} segmentos fueron asignados con mínimo desperdicio.\n'
        '   No hay solapamiento entre subredes.',
      );
    } else {
      steps.add(
        '📋 VLSM Overview\n'
        '   Base Network   : $baseNetwork/$basePrefix\n'
        '   Total Segments : ${results.length}\n\n'
        '   VLSM allocates different-sized subnets\n'
        '   from a single address block.\n'
        '   Segments are sorted largest → smallest\n'
        '   to minimize wasted IP space.',
      );
      for (int i = 0; i < results.length; i++) {
        final r = results[i];
        steps.add(
          '📌 Step ${i + 2} — Allocate "${r.name}"\n'
          '   Required hosts : ${r.requiredHosts}\n'
          '   Needed prefix  : /${r.cidrPrefix} '
          '(${r.usableHosts} usable hosts)\n'
          '   Network        : ${r.networkAddress}/${r.cidrPrefix}\n'
          '   Subnet Mask    : ${r.subnetMask}\n'
          '   Range          : ${r.firstHost} — ${r.lastHost}\n'
          '   Broadcast      : ${r.broadcastAddress}',
        );
      }
      steps.add(
        '✅ Allocation Complete\n'
        '   All ${results.length} segments allocated with minimum waste.\n'
        '   No IP address space overlap between subnets.',
      );
    }
    return steps;
  }
}
