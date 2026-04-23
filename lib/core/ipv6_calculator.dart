/// IPv6Calculator
/// Pure business logic for IPv6 address analysis and prefix calculations.
/// No Flutter imports — testable Dart code.

import '../models/subnet_result.dart';

class IPv6Calculator {
  IPv6Calculator._();

  /// Expands a compressed IPv6 address to full notation.
  /// e.g. '2001:db8::1' → '2001:0db8:0000:0000:0000:0000:0000:0001'
  static String expand(String address) {
    address = address.trim().toLowerCase();

    // Handle '::' — replace with the correct number of zero groups
    if (address.contains('::')) {
      final parts = address.split('::');
      final left = parts[0].isEmpty ? <String>[] : parts[0].split(':');
      final right = parts[1].isEmpty ? <String>[] : parts[1].split(':');
      final missing = 8 - left.length - right.length;
      final middle = List.filled(missing, '0000');
      final groups = [...left, ...middle, ...right];
      return groups.map((g) => g.padLeft(4, '0')).join(':');
    }

    return address.split(':').map((g) => g.padLeft(4, '0')).join(':');
  }

  /// Compresses a full IPv6 address to shortest notation.
  static String compress(String fullAddress) {
    // Remove leading zeros in each group
    final groups =
        fullAddress.split(':').map((g) => g.replaceFirst(RegExp(r'^0+'), '') == '' ? '0' : g.replaceFirst(RegExp(r'^0+'), '')).toList();

    // Find the longest run of consecutive '0' groups for '::'
    int bestStart = -1, bestLen = 0;
    int start = -1, len = 0;
    for (int i = 0; i < groups.length; i++) {
      if (groups[i] == '0') {
        if (start == -1) {
          start = i;
          len = 1;
        } else {
          len++;
        }
        if (len > bestLen) {
          bestLen = len;
          bestStart = start;
        }
      } else {
        start = -1;
        len = 0;
      }
    }

    if (bestLen >= 2) {
      final before = groups.sublist(0, bestStart).join(':');
      final after = groups.sublist(bestStart + bestLen).join(':');
      if (before.isEmpty && after.isEmpty) return '::';
      if (before.isEmpty) return '::$after';
      if (after.isEmpty) return '$before::';
      return '$before::$after';
    }

    return groups.join(':');
  }

  /// Validates an IPv6 address string.
  static bool isValid(String address) {
    try {
      expand(address.trim());
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Returns the type of the IPv6 address.
  static String addressType(String address) {
    final full = expand(address);
    if (full.startsWith('fe80')) return 'Link-Local (fe80::/10)';
    if (full.startsWith('2001:0db8')) return 'Documentation (2001:db8::/32)';
    if (full.startsWith('fc') || full.startsWith('fd')) {
      return 'Unique Local (fc00::/7)';
    }
    if (full.startsWith('ff')) return 'Multicast (ff00::/8)';
    if (full == '0000:0000:0000:0000:0000:0000:0000:0001') {
      return 'Loopback (::1)';
    }
    if (full == '0000:0000:0000:0000:0000:0000:0000:0000') {
      return 'Unspecified (::)';
    }
    if (full.startsWith('2') || full.startsWith('3')) {
      return 'Global Unicast (2000::/3)';
    }
    return 'Unknown';
  }

  /// Calculates the number of addresses in a prefix.
  static BigInt addressCount(int prefixLength) {
    return BigInt.two.pow(128 - prefixLength);
  }

  /// Performs a full IPv6 prefix analysis.
  static IPv6SubnetResult calculate(String address, int prefix) {
    if (prefix < 0 || prefix > 128) {
      throw ArgumentError('Prefix must be 0–128');
    }

    final expanded = expand(address);
    final networkInt = _expandToInt(expanded);

    // Calculate network address (zero out host bits)
    final hostBits = 128 - prefix;
    final networkInt2 = hostBits >= 128
        ? BigInt.zero
        : (networkInt >> hostBits) << hostBits;

    // First host = network + 1
    final firstHostInt = networkInt2 + BigInt.one;
    // Last host = network | hostMask - 1
    final hostMask = hostBits >= 128
        ? BigInt.two.pow(128) - BigInt.one
        : BigInt.two.pow(hostBits) - BigInt.one;
    final lastHostInt = networkInt2 | hostMask;

    final networkStr = compress(_intToIpv6(networkInt2));
    final firstStr = compress(_intToIpv6(firstHostInt));
    final lastStr = compress(_intToIpv6(lastHostInt));
    final count = addressCount(prefix);
    final type = addressType(address);

    final steps = _buildSteps(address, prefix, expanded, networkStr,
        firstStr, lastStr, count, type);
    final stepsEn = _buildStepsEn(address, prefix, expanded, networkStr,
        firstStr, lastStr, count, type);

    return IPv6SubnetResult(
      networkAddress: networkStr,
      firstHost: firstStr,
      lastHost: lastStr,
      prefixLength: prefix,
      totalAddresses: count,
      addressType: type,
      steps: steps,
      stepsEn: stepsEn,
    );
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  static BigInt _expandToInt(String full) {
    final groups = full.split(':');
    BigInt result = BigInt.zero;
    for (final g in groups) {
      result = (result << 16) | BigInt.parse(g, radix: 16);
    }
    return result;
  }

  static String _intToIpv6(BigInt value) {
    final groups = <String>[];
    for (int i = 0; i < 8; i++) {
      groups.insert(0, (value & BigInt.from(0xFFFF)).toRadixString(16).padLeft(4, '0'));
      value = value >> 16;
    }
    return groups.join(':');
  }

  static List<String> _buildSteps(
    String original,
    int prefix,
    String expanded,
    String network,
    String first,
    String last,
    BigInt count,
    String type,
  ) {
    return [
      '🔢 Step 1 — Expand the address\n'
          '   Input   : $original/$prefix\n'
          '   Expanded: $expanded\n'
          '   This shows all 128 bits explicitly.',

      '🏷️ Step 2 — Identify address type\n'
          '   Type: $type\n'
          '   The first bits determine the address scope and usage.',

      '🌐 Step 3 — Calculate network prefix\n'
          '   /$prefix means the first $prefix bits identify the network.\n'
          '   The remaining ${128 - prefix} bits are available for hosts.\n'
          '   Network Address: $network/$prefix',

      '👥 Step 4 — Address range\n'
          '   First address : $first\n'
          '   Last address  : $last\n'
          '   Total addresses: $count\n'
          '   (${128 - prefix} host bits = 2^${128 - prefix} addresses)',
    ];
  }

  static List<String> _buildStepsEn(
    String original,
    int prefix,
    String expanded,
    String network,
    String first,
    String last,
    BigInt count,
    String type,
  ) {
    return [
      '🔢 Paso 1 — Expandir la dirección\n'
          '   Entrada  : $original/$prefix\n'
          '   Expandida: $expanded\n'
          '   Muestra los 128 bits de forma explícita.',

      '🏷️ Paso 2 — Identificar tipo de dirección\n'
          '   Tipo: $type\n'
          '   Los primeros bits determinan el alcance y uso.',

      '🌐 Paso 3 — Calcular prefijo de red\n'
          '   /$prefix significa que los primeros $prefix bits identifican la red.\n'
          '   Los ${128 - prefix} bits restantes son para hosts.\n'
          '   Dirección de Red: $network/$prefix',

      '👥 Paso 4 — Rango de direcciones\n'
          '   Primera dir. : $first\n'
          '   Última dir.  : $last\n'
          '   Total dir.   : $count\n'
          '   (${128 - prefix} bits de host = 2^${128 - prefix} direcciones)',
    ];
  }
}