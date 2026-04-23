/// ConfigGenerator
/// Generates Cisco IOS-style configuration blocks from models.
/// All output is plain text suitable for copy/paste into a router terminal.

import '../models/vlan_model.dart';
import '../models/nat_model.dart';
import '../models/route_model.dart';

class ConfigGenerator {
  ConfigGenerator._();

  // ──────────────────────────────────────────────────────────────────────────
  //  Router-on-a-Stick (IEEE 802.1Q inter-VLAN routing)
  // ──────────────────────────────────────────────────────────────────────────

  /// Generates a full Router-on-a-Stick configuration.
  ///
  /// [trunkInterface] — the physical interface connected to the trunk switch port
  ///                    (e.g. 'GigabitEthernet0/0')
  /// [vlans]          — list of VlanModel objects to configure
  static String routerOnStick({
    required String trunkInterface,
    required List<VlanModel> vlans,
    String hostname = 'Router',
  }) {
    final sb = StringBuffer();

    sb.writeln(_header('Router-on-a-Stick Configuration'));
    sb.writeln('hostname $hostname');
    sb.writeln('!');
    sb.writeln('! Enable the physical trunk interface (no IP assigned)');
    sb.writeln('interface $trunkInterface');
    sb.writeln(' no shutdown');
    sb.writeln(' no ip address');
    sb.writeln('!');

    for (final vlan in vlans) {
      final subIf = vlan.subInterface(trunkInterface);
      sb.writeln('! Sub-interface for VLAN ${vlan.vlanId} — ${vlan.name}');
      sb.writeln('interface $subIf');
      sb.writeln(' encapsulation dot1Q ${vlan.vlanId}');
      sb.writeln(' ip address ${vlan.gatewayIp} ${vlan.subnetMask}');
      sb.writeln(' no shutdown');
      sb.writeln('!');
    }

    sb.writeln(_footer());
    return sb.toString();
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  Switch VLAN Configuration
  // ──────────────────────────────────────────────────────────────────────────

  /// Generates a Cisco switch configuration for VLANs with trunk/access ports.
  static String switchVlanConfig({
    required List<VlanModel> vlans,
    required String trunkPort,
    String hostname = 'Switch',
  }) {
    final sb = StringBuffer();

    sb.writeln(_header('Switch VLAN Configuration'));
    sb.writeln('hostname $hostname');
    sb.writeln('!');

    // Create VLANs in database
    sb.writeln('! — VLAN Database —');
    for (final vlan in vlans) {
      sb.writeln('vlan ${vlan.vlanId}');
      sb.writeln(' name ${vlan.name}');
      sb.writeln('!');
    }

    // Trunk port to router
    sb.writeln('! — Trunk port to router —');
    sb.writeln('interface $trunkPort');
    sb.writeln(' switchport mode trunk');
    sb.writeln(' switchport trunk encapsulation dot1q');

    final vlanList = vlans.map((v) => v.vlanId.toString()).join(',');
    sb.writeln(' switchport trunk allowed vlan $vlanList');
    sb.writeln(' no shutdown');
    sb.writeln('!');

    // Access port examples
    sb.writeln('! — Access port example (one per VLAN) —');
    for (int i = 0; i < vlans.length; i++) {
      sb.writeln('interface FastEthernet0/${i + 1}');
      sb.writeln(' switchport mode access');
      sb.writeln(' switchport access vlan ${vlans[i].vlanId}');
      sb.writeln(' no shutdown');
      sb.writeln('!');
    }

    sb.writeln(_footer());
    return sb.toString();
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  Static Routes
  // ──────────────────────────────────────────────────────────────────────────

  /// Generates static route configuration commands.
  static String staticRoutes({
    required List<RouteModel> routes,
    String hostname = 'Router',
  }) {
    final sb = StringBuffer();
    sb.writeln(_header('Static Route Configuration'));
    sb.writeln('hostname $hostname');
    sb.writeln('!');
    sb.writeln('! Static Routes');
    for (final route in routes) {
      if (route.description != null) sb.writeln('! ${route.description}');
      sb.writeln(route.toCiscoCommand());
    }
    sb.writeln('!');
    sb.writeln(_footer());
    return sb.toString();
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  NAT Configuration
  // ──────────────────────────────────────────────────────────────────────────

  /// Generates NAT configuration commands based on NatModel.
  static String natConfig(NatModel nat) {
    final sb = StringBuffer();
    sb.writeln(_header('NAT Configuration'));

    // Tag inside/outside interfaces
    sb.writeln('! — Interface NAT roles —');
    sb.writeln('interface ${nat.insideInterface}');
    sb.writeln(' ip nat inside');
    sb.writeln('!');
    sb.writeln('interface ${nat.outsideInterface}');
    sb.writeln(' ip nat outside');
    sb.writeln('!');

    switch (nat.type) {
      case NatType.staticNat:
        sb.writeln('! — Static NAT (one-to-one mapping) —');
        sb.writeln(
            'ip nat inside source static ${nat.privateIp} ${nat.publicIp}');
        break;

      case NatType.dynamicNat:
        sb.writeln('! — Dynamic NAT (pool) —');
        sb.writeln(
            'ip nat pool ${nat.poolName} ${nat.poolStartIp} ${nat.poolEndIp} netmask 255.255.255.0');
        sb.writeln(
            'ip nat inside source list ${nat.aclNumber} pool ${nat.poolName}');
        sb.writeln('!');
        sb.writeln('! Access list to match inside traffic');
        sb.writeln('access-list ${nat.aclNumber} permit ${nat.insideNetwork} 0.0.0.255');
        break;

      case NatType.pat:
        sb.writeln('! — PAT / NAT Overload (many-to-one) —');
        sb.writeln(
            'ip nat inside source list ${nat.aclNumber} interface ${nat.outsideInterface} overload');
        sb.writeln('!');
        sb.writeln('! Access list to match inside traffic');
        sb.writeln(
            'access-list ${nat.aclNumber} permit ${nat.insideNetwork} 0.0.0.255');
        break;
    }

    sb.writeln('!');
    sb.writeln(_footer());
    return sb.toString();
  }

  // ──────────────────────────────────────────────────────────────────────────
  //  Helpers
  // ──────────────────────────────────────────────────────────────────────────

  static String _header(String title) {
    final line = '!' * 60;
    return '$line\n! $title\n! Generated by Network Engineering Assistant\n$line';
  }

  static String _footer() {
    return '! — End of configuration —\nend\n';
  }
}
