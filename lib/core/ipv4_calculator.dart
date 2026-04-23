/// IPv4Calculator
/// Pure business logic for IPv4 subnetting.
/// No Flutter imports — this is testable Dart code.

import '../models/subnet_result.dart';
import '../utils/ip_utils.dart';

class IPv4Calculator {
  IPv4Calculator._();

  /// Calculates a full subnet breakdown given an IP and CIDR prefix.
  ///
  /// Throws [ArgumentError] if the input is invalid.
  static SubnetResult calculate(String ip, int prefix) {
    // ── Validate input ──────────────────────────────────────────────────────
    if (!IpUtils.isValidIp(ip)) {
      throw ArgumentError('Invalid IPv4 address: $ip');
    }
    if (!IpUtils.isValidPrefix(prefix)) {
      throw ArgumentError('Invalid prefix: $prefix (must be 0-32)');
    }

    // ── Detect host IP (not a network address) ──────────────────────────────
    // If the entered IP has host bits set, it is a host address, not a network
    // address. We do NOT silently correct it — instead we throw a clear error.
    final computedNetwork = IpUtils.networkAddress(ip, prefix);
    if (computedNetwork != ip.trim()) {
      throw ArgumentError(
        'The address $ip/$prefix is a host address, not a network address.\n'
        'Did you mean the network $computedNetwork/$prefix?',
      );
    }

    // ── Compute values ──────────────────────────────────────────────────────
    final network = IpUtils.networkAddress(ip, prefix);
    final broadcast = IpUtils.broadcastAddress(ip, prefix);
    final mask = IpUtils.prefixToMask(prefix);
    final wildcard = IpUtils.maskToWildcard(mask);
    final first = IpUtils.firstHost(ip, prefix);
    final last = IpUtils.lastHost(ip, prefix);
    final total = IpUtils.totalAddresses(prefix);
    final usable = IpUtils.usableHosts(prefix);
    final ipClass = IpUtils.ipClass(ip);
    final isPrivate = IpUtils.isPrivate(ip);

    // ── Generate step-by-step explanation ──────────────────────────────────
    final steps = _buildSteps(ip, prefix, network, broadcast, mask, wildcard,
        first, last, total, usable);
    final stepsEn = _buildStepsEn(ip, prefix, network, broadcast, mask, wildcard,
        first, last, total, usable);

    return SubnetResult(
      networkAddress: network,
      broadcastAddress: broadcast,
      subnetMask: mask,
      wildcardMask: wildcard,
      firstHost: first,
      lastHost: last,
      totalHosts: total,
      usableHosts: usable,
      cidrPrefix: prefix,
      ipClass: ipClass,
      isPrivate: isPrivate,
      steps: steps,
      stepsEn: stepsEn,
    );
  }

  /// Calculates how many subnets can be created from a network with a new prefix.
  static int subnetsCount(int originalPrefix, int newPrefix) {
    if (newPrefix <= originalPrefix) return 0;
    return 1 << (newPrefix - originalPrefix);
  }

  /// Generates all subnets of a network given a longer prefix.
  static List<SubnetResult> generateSubnets(
      String networkIp, int originalPrefix, int newPrefix) {
    final count = subnetsCount(originalPrefix, newPrefix);
    final results = <SubnetResult>[];

    String current = IpUtils.networkAddress(networkIp, originalPrefix);
    for (int i = 0; i < count; i++) {
      results.add(calculate(current, newPrefix));
      current = IpUtils.nextNetwork(current, newPrefix);
    }
    return results;
  }

  // ── Private: explanation builder ─────────────────────────────────────────

  static List<String> _buildSteps(
    String ip,
    int prefix,
    String network,
    String broadcast,
    String mask,
    String wildcard,
    String first,
    String last,
    int total,
    int usable,
  ) {
    final ipBin = IpUtils.toBinaryDotted(ip);
    final maskBin = IpUtils.toBinaryDotted(mask);

    return [
      '🔢 Paso 1 — Identificar la dirección dada\n'
          '   Dir. IP    : $ip\n'
          '   CIDR       : /$prefix\n'
          '   Binario    : $ipBin',

      '🎭 Paso 2 — Convertir CIDR a Máscara de Subred\n'
          '   /$prefix significa los primeros $prefix bits en 1.\n'
          '   Máscara    : $mask\n'
          '   Binario    : $maskBin',

      '🌐 Paso 3 — Calcular Dirección de Red\n'
          '   AND bit a bit: IP AND Máscara de Subred\n'
          '   $ip  AND\n'
          '   $mask\n'
          '   = $network\n'
          '   Binario IP  : $ipBin\n'
          '   AND Máscara : $maskBin',

      '📡 Paso 4 — Calcular Dirección Broadcast\n'
          '   Wildcard = NOT bit a bit de la Máscara\n'
          '   Wildcard  : $wildcard\n'
          '   Broadcast = Red OR Wildcard\n'
          '   = $broadcast',

      '👥 Paso 5 — Calcular Hosts Utilizables\n'
          '   Total dir.    = 2^(32-$prefix) = $total\n'
          '   Hosts utiliz. = $total - 2 = $usable\n'
          '   (Se restan dir. de red y broadcast)\n'
          '   Primer host : $first\n'
          '   Último host : $last',

      '📋 Paso 6 — Resumen\n'
          '   Red         : $network/$prefix\n'
          '   Máscara     : $mask\n'
          '   Wildcard    : $wildcard\n'
          '   Broadcast   : $broadcast\n'
          '   Hosts       : $first — $last ($usable utilizables)',
    ];
  }

  static List<String> _buildStepsEn(
    String ip,
    int prefix,
    String network,
    String broadcast,
    String mask,
    String wildcard,
    String first,
    String last,
    int total,
    int usable,
  ) {
    final ipBin = IpUtils.toBinaryDotted(ip);
    final maskBin = IpUtils.toBinaryDotted(mask);

    return [
      '🔢 Step 1 — Identify the given address\n'
          '   IP Address : $ip\n'
          '   CIDR       : /$prefix\n'
          '   Binary     : $ipBin',

      '🎭 Step 2 — Convert CIDR to Subnet Mask\n'
          '   /$prefix means the first $prefix bits are 1s.\n'
          '   Subnet Mask: $mask\n'
          '   Binary     : $maskBin',

      '🌐 Step 3 — Calculate Network Address\n'
          '   Perform bitwise AND: IP AND Subnet Mask\n'
          '   $ip  AND\n'
          '   $mask\n'
          '   = $network\n'
          '   Binary: $ipBin\n'
          '   AND:    $maskBin',

      '📡 Step 4 — Calculate Broadcast Address\n'
          '   Wildcard Mask = bitwise NOT of Subnet Mask\n'
          '   Wildcard: $wildcard\n'
          '   Broadcast = Network OR Wildcard\n'
          '   = $broadcast',

      '👥 Step 5 — Calculate Usable Hosts\n'
          '   Total addresses = 2^(32-$prefix) = $total\n'
          '   Usable hosts    = $total - 2 = $usable\n'
          '   (Subtract network address and broadcast)\n'
          '   First usable: $first\n'
          '   Last usable : $last',

      '📋 Step 6 — Summary\n'
          '   Network   : $network/$prefix\n'
          '   Mask      : $mask\n'
          '   Wildcard  : $wildcard\n'
          '   Broadcast : $broadcast\n'
          '   Hosts     : $first — $last ($usable usable)',
    ];
  }
}
