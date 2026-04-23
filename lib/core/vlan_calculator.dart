/// VlanCalculator
/// Core logic for VLAN IP assignment and configuration planning.
/// Produces VlanModel objects ready for the config engine.

import '../models/vlan_model.dart';
import '../utils/ip_utils.dart';

class VlanCalculator {
  VlanCalculator._();

  /// Creates a VlanModel by computing gateway and subnet info
  /// for a given VLAN ID, name, network address, and prefix.
  ///
  /// Convention: gateway is the first usable host (.1 by default).
  static VlanModel create({
    required int vlanId,
    required String name,
    required String networkAddress,
    required int cidrPrefix,
  }) {
    final network = IpUtils.networkAddress(networkAddress, cidrPrefix);
    final mask = IpUtils.prefixToMask(cidrPrefix);
    final gateway = IpUtils.firstHost(network, cidrPrefix);
    final usable = IpUtils.usableHosts(cidrPrefix);

    return VlanModel(
      vlanId: vlanId,
      name: name,
      networkAddress: network,
      cidrPrefix: cidrPrefix,
      gatewayIp: gateway,
      subnetMask: mask,
      usableHosts: usable,
    );
  }

  /// Validates that no two VLANs share overlapping address space.
  static List<String> checkOverlaps(List<VlanModel> vlans) {
    final conflicts = <String>[];
    for (int i = 0; i < vlans.length; i++) {
      for (int j = i + 1; j < vlans.length; j++) {
        if (_overlaps(vlans[i], vlans[j])) {
          conflicts.add(
              'VLAN ${vlans[i].vlanId} (${vlans[i].networkAddress}/${vlans[i].cidrPrefix}) '
              'overlaps with VLAN ${vlans[j].vlanId} (${vlans[j].networkAddress}/${vlans[j].cidrPrefix})');
        }
      }
    }
    return conflicts;
  }

  static bool _overlaps(VlanModel a, VlanModel b) {
    final aStart = IpUtils.ipToInt(a.networkAddress);
    final aEnd = IpUtils.ipToInt(IpUtils.broadcastAddress(a.networkAddress, a.cidrPrefix));
    final bStart = IpUtils.ipToInt(b.networkAddress);
    final bEnd = IpUtils.ipToInt(IpUtils.broadcastAddress(b.networkAddress, b.cidrPrefix));
    return aStart <= bEnd && bStart <= aEnd;
  }
}
