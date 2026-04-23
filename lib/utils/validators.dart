/// Validators
/// Input validation helpers used by form fields across the UI.
/// All functions return null on success, or an error message string.

import 'ip_utils.dart';

class Validators {
  Validators._();

  /// Validates a dotted-decimal IPv4 address.
  static String? ipv4(String? value) {
    if (value == null || value.isEmpty) return 'IP address is required';
    if (!IpUtils.isValidIp(value.trim())) {
      return 'Enter a valid IPv4 address (e.g. 192.168.1.0)';
    }
    return null;
  }

  /// Validates a CIDR prefix (1-32 for subnetting, 0-32 for routing).
  static String? cidrPrefix(String? value, {int min = 1, int max = 32}) {
    if (value == null || value.isEmpty) return 'Prefix is required';
    final n = int.tryParse(value.trim());
    if (n == null) return 'Enter a number';
    if (n < min || n > max) return 'Prefix must be between $min and $max';
    return null;
  }

  /// Validates a positive integer (e.g. host count).
  static String? positiveInt(String? value, {String label = 'Value'}) {
    if (value == null || value.isEmpty) return '$label is required';
    final n = int.tryParse(value.trim());
    if (n == null || n <= 0) return '$label must be a positive integer';
    return null;
  }

  /// Validates a VLAN ID (1-4094).
  static String? vlanId(String? value) {
    if (value == null || value.isEmpty) return 'VLAN ID is required';
    final n = int.tryParse(value.trim());
    if (n == null || n < 1 || n > 4094) {
      return 'VLAN ID must be between 1 and 4094';
    }
    // Reserved VLANs
    if (n >= 1002 && n <= 1005) {
      return 'VLANs 1002-1005 are reserved for legacy protocols';
    }
    return null;
  }

  /// Validates that an IP is a proper network address for given prefix
  /// (i.e. host bits must all be zero). Returns null if valid.
  static String? networkAddress(String? ip, String? prefix) {
    if (ip == null || ip.trim().isEmpty) return 'IP address is required';
    if (prefix == null || prefix.trim().isEmpty) return 'Prefix is required';
    final p = int.tryParse(prefix.trim());
    if (p == null || p < 0 || p > 32) return null; // let prefix validator handle
    try {
      final ipStr = ip.trim();
      // Check if IP with this prefix yields the same network address
      final computed = IpUtils.networkAddress(ipStr, p);
      if (computed != ipStr) {
        return 'Use network address: $computed (not a host/subnet address)';
      }
    } catch (_) { return null; }
    return null;
  }

  /// Validates a non-empty string field.
  static String? required(String? value, {String label = 'Field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  /// Validates a Cisco interface name (e.g. GigabitEthernet0/0, G0/0, fa0/0).
  static String? interfaceName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Interface name is required';
    final pattern = RegExp(
      r'^(GigabitEthernet|FastEthernet|Serial|Loopback|Ethernet|g|G|f|F|s|S|lo|Lo)\d+(/\d+)*$',
      caseSensitive: false,
    );
    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid interface (e.g. G0/0, GigabitEthernet0/1)';
    }
    return null;
  }
}
