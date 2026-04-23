/// SubnetResult
/// Immutable data model for IPv4 subnet calculation results.
/// All fields are computed by core/ipv4_calculator.dart — never in UI.

class SubnetResult {
  final String networkAddress;
  final String broadcastAddress;
  final String subnetMask;
  final String wildcardMask;
  final String firstHost;
  final String lastHost;
  final int totalHosts;
  final int usableHosts;
  final int cidrPrefix;
  final String ipClass;
  final bool isPrivate;
  final List<String> steps; // step-by-step explanation (Spanish)
  final List<String> stepsEn; // step-by-step explanation (English)

  const SubnetResult({
    required this.networkAddress,
    required this.broadcastAddress,
    required this.subnetMask,
    required this.wildcardMask,
    required this.firstHost,
    required this.lastHost,
    required this.totalHosts,
    required this.usableHosts,
    required this.cidrPrefix,
    required this.ipClass,
    required this.isPrivate,
    required this.steps,
    required this.stepsEn,
  });

  /// Returns a map for display / export
  Map<String, String> toDisplayMap() => {
        'Network Address': networkAddress,
        'Broadcast Address': broadcastAddress,
        'Subnet Mask': subnetMask,
        'Wildcard Mask': wildcardMask,
        'First Host': firstHost,
        'Last Host': lastHost,
        'Total Hosts': totalHosts.toString(),
        'Usable Hosts': usableHosts.toString(),
        'CIDR Prefix': '/$cidrPrefix',
        'IP Class': ipClass,
        'Private Range': isPrivate ? 'Yes (RFC 1918)' : 'No (Public)',
      };
}

/// IPv6SubnetResult
/// Immutable data model for IPv6 prefix calculation results.
class IPv6SubnetResult {
  final String networkAddress;
  final String firstHost;
  final String lastHost;
  final int prefixLength;
  final BigInt totalAddresses;
  final String addressType;
  final List<String> steps;
  final List<String> stepsEn;

  const IPv6SubnetResult({
    required this.networkAddress,
    required this.firstHost,
    required this.lastHost,
    required this.prefixLength,
    required this.totalAddresses,
    required this.addressType,
    required this.steps,
    required this.stepsEn,
  });
}
