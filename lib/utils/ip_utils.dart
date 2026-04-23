/// IpUtils
/// Low-level utility functions for IP address manipulation.
/// All functions are pure — no side effects, no UI dependencies.

class IpUtils {
  IpUtils._(); // Prevent instantiation

  // ─── IPv4 Conversions ───────────────────────────────────────────────────

  /// Converts a dotted-decimal IPv4 string to a 32-bit integer.
  /// e.g. '192.168.1.0' → 3232235776
  static int ipToInt(String ip) {
    final parts = ip.trim().split('.');
    if (parts.length != 4) throw ArgumentError('Invalid IPv4: $ip');
    int result = 0;
    for (final part in parts) {
      final octet = int.parse(part);
      if (octet < 0 || octet > 255) throw ArgumentError('Octet out of range: $octet');
      result = (result << 8) | octet;
    }
    return result;
  }

  /// Converts a 32-bit integer to dotted-decimal IPv4 string.
  static String intToIp(int value) {
    final a = (value >> 24) & 0xFF;
    final b = (value >> 16) & 0xFF;
    final c = (value >> 8) & 0xFF;
    final d = value & 0xFF;
    return '$a.$b.$c.$d';
  }

  /// Converts a CIDR prefix length to a 32-bit subnet mask integer.
  /// /24 → 0xFFFFFF00
  static int prefixToMaskInt(int prefix) {
    if (prefix < 0 || prefix > 32) throw ArgumentError('Prefix out of range: $prefix');
    if (prefix == 0) return 0;
    return (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
  }

  /// Converts a CIDR prefix length to dotted-decimal mask string.
  static String prefixToMask(int prefix) =>
      intToIp(prefixToMaskInt(prefix));

  /// Converts a dotted-decimal mask to CIDR prefix length.
  static int maskToPrefix(String mask) {
    final maskInt = ipToInt(mask);
    return _countBits(maskInt);
  }

  /// Converts a subnet mask to wildcard mask (bitwise NOT).
  static String maskToWildcard(String mask) {
    final maskInt = ipToInt(mask);
    return intToIp(~maskInt & 0xFFFFFFFF);
  }

  /// Counts set bits in a 32-bit integer (popcount).
  static int _countBits(int n) {
    int count = 0;
    int val = n & 0xFFFFFFFF;
    while (val != 0) {
      count += val & 1;
      val >>= 1;
    }
    return count;
  }

  // ─── Network Address Computation ───────────────────────────────────────

  /// Returns the network address (IP AND mask).
  static String networkAddress(String ip, int prefix) {
    final ipInt = ipToInt(ip);
    final maskInt = prefixToMaskInt(prefix);
    return intToIp(ipInt & maskInt);
  }

  /// Returns the broadcast address (network OR ~mask).
  static String broadcastAddress(String ip, int prefix) {
    final ipInt = ipToInt(ip);
    final maskInt = prefixToMaskInt(prefix);
    final networkInt = ipInt & maskInt;
    final wildcardInt = ~maskInt & 0xFFFFFFFF;
    return intToIp(networkInt | wildcardInt);
  }

  /// Returns the first usable host (network + 1).
  static String firstHost(String ip, int prefix) {
    if (prefix >= 31) return networkAddress(ip, prefix);
    final networkInt = ipToInt(networkAddress(ip, prefix));
    return intToIp(networkInt + 1);
  }

  /// Returns the last usable host (broadcast - 1).
  static String lastHost(String ip, int prefix) {
    if (prefix >= 31) return broadcastAddress(ip, prefix);
    final broadcastInt = ipToInt(broadcastAddress(ip, prefix));
    return intToIp(broadcastInt - 1);
  }

  // ─── Host Counting ─────────────────────────────────────────────────────

  /// Total addresses in the subnet (2^(32-prefix)).
  static int totalAddresses(int prefix) => 1 << (32 - prefix);

  /// Usable host addresses (total - 2, for network & broadcast).
  static int usableHosts(int prefix) {
    if (prefix == 32) return 1;
    if (prefix == 31) return 2; // RFC 3021: point-to-point
    return totalAddresses(prefix) - 2;
  }

  // ─── IP Classification ─────────────────────────────────────────────────

  /// Returns the IP class (A, B, C, D multicast, E reserved).
  static String ipClass(String ip) {
    final first = int.parse(ip.split('.')[0]);
    if (first < 128) return 'A';
    if (first < 192) return 'B';
    if (first < 224) return 'C';
    if (first < 240) return 'D (Multicast)';
    return 'E (Reserved)';
  }

  /// Returns true if the IP is in an RFC 1918 private range.
  static bool isPrivate(String ip) {
    final n = ipToInt(ip);
    // 10.0.0.0/8
    if ((n & 0xFF000000) == 0x0A000000) return true;
    // 172.16.0.0/12
    if ((n & 0xFFF00000) == 0xAC100000) return true;
    // 192.168.0.0/16
    if ((n & 0xFFFF0000) == 0xC0A80000) return true;
    return false;
  }

  // ─── Validation ────────────────────────────────────────────────────────

  /// Validates that a string is a valid dotted-decimal IPv4 address.
  static bool isValidIp(String ip) {
    try {
      final parts = ip.trim().split('.');
      if (parts.length != 4) return false;
      return parts.every((p) {
        final n = int.tryParse(p);
        return n != null && n >= 0 && n <= 255;
      });
    } catch (_) {
      return false;
    }
  }

  /// Validates CIDR prefix (0-32).
  static bool isValidPrefix(int prefix) => prefix >= 0 && prefix <= 32;

  // ─── Binary Representation ─────────────────────────────────────────────

  /// Returns the binary dotted representation of an IPv4 address.
  /// e.g. '11000000.10101000.00000001.00000001'
  static String toBinaryDotted(String ip) {
    return ip
        .split('.')
        .map((o) => int.parse(o).toRadixString(2).padLeft(8, '0'))
        .join('.');
  }

  // ─── Next Network ──────────────────────────────────────────────────────

  /// Returns the first IP of the next subnet (for VLSM chaining).
  static String nextNetwork(String networkIp, int prefix) {
    final broadcastInt = ipToInt(broadcastAddress(networkIp, prefix));
    return intToIp(broadcastInt + 1);
  }
}
