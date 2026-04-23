/// VlanModel
/// Represents a single VLAN configuration entry.

class VlanModel {
  final int vlanId;
  final String name;
  final String networkAddress;
  final int cidrPrefix;
  final String gatewayIp;
  final String subnetMask;
  final int usableHosts;

  const VlanModel({
    required this.vlanId,
    required this.name,
    required this.networkAddress,
    required this.cidrPrefix,
    required this.gatewayIp,
    required this.subnetMask,
    required this.usableHosts,
  });

  /// VLAN interface name used in Cisco IOS
  String get interfaceName => 'Vlan$vlanId';

  /// Sub-interface notation for Router-on-a-Stick
  String subInterface(String baseInterface) =>
      '$baseInterface.$vlanId';

  Map<String, String> toDisplayMap() => {
        'VLAN ID': vlanId.toString(),
        'Name': name,
        'Network': '$networkAddress/$cidrPrefix',
        'Subnet Mask': subnetMask,
        'Gateway': gatewayIp,
        'Usable Hosts': usableHosts.toString(),
      };

  VlanModel copyWith({
    int? vlanId,
    String? name,
    String? networkAddress,
    int? cidrPrefix,
    String? gatewayIp,
    String? subnetMask,
    int? usableHosts,
  }) {
    return VlanModel(
      vlanId: vlanId ?? this.vlanId,
      name: name ?? this.name,
      networkAddress: networkAddress ?? this.networkAddress,
      cidrPrefix: cidrPrefix ?? this.cidrPrefix,
      gatewayIp: gatewayIp ?? this.gatewayIp,
      subnetMask: subnetMask ?? this.subnetMask,
      usableHosts: usableHosts ?? this.usableHosts,
    );
  }
}

/// VlsmEntry
/// Input for VLSM calculator: a network segment with required host count.
class VlsmEntry {
  final String name;
  final int requiredHosts;

  const VlsmEntry({required this.name, required this.requiredHosts});
}

/// VlsmResult
/// Output of VLSM calculator for one segment.
class VlsmResult {
  final String name;
  final int requiredHosts;
  final String networkAddress;
  final String subnetMask;
  final String firstHost;
  final String lastHost;
  final String broadcastAddress;
  final int usableHosts;
  final int cidrPrefix;

  const VlsmResult({
    required this.name,
    required this.requiredHosts,
    required this.networkAddress,
    required this.subnetMask,
    required this.firstHost,
    required this.lastHost,
    required this.broadcastAddress,
    required this.usableHosts,
    required this.cidrPrefix,
  });

  Map<String, String> toDisplayMap() => {
        'Segment': name,
        'Required Hosts': requiredHosts.toString(),
        'Network': '$networkAddress/$cidrPrefix',
        'Subnet Mask': subnetMask,
        'First Host': firstHost,
        'Last Host': lastHost,
        'Broadcast': broadcastAddress,
        'Usable Hosts': usableHosts.toString(),
      };
}
