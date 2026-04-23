/// RouteModel
/// Represents a static route configuration entry.

enum RouteType { ipv4Static, ipv4Default, ipv6Static, ipv6Default }

class RouteModel {
  final String destinationNetwork;
  final int cidrPrefix;
  final String nextHop; // next-hop IP or exit interface
  final int? adminDistance; // optional administrative distance
  final RouteType type;
  final String? description;

  const RouteModel({
    required this.destinationNetwork,
    required this.cidrPrefix,
    required this.nextHop,
    this.adminDistance,
    required this.type,
    this.description,
  });

  /// Generates a Cisco IOS static route command
  String toCiscoCommand() {
    final ad = adminDistance != null ? ' ${adminDistance}' : '';
    switch (type) {
      case RouteType.ipv4Default:
        return 'ip route 0.0.0.0 0.0.0.0 $nextHop$ad';
      case RouteType.ipv4Static:
        final mask = _cidrToMask(cidrPrefix);
        return 'ip route $destinationNetwork $mask $nextHop$ad';
      case RouteType.ipv6Default:
        return 'ipv6 route ::/0 $nextHop$ad';
      case RouteType.ipv6Static:
        return 'ipv6 route $destinationNetwork/$cidrPrefix $nextHop$ad';
    }
  }

  String _cidrToMask(int prefix) {
    final bits = (0xFFFFFFFF << (32 - prefix)) & 0xFFFFFFFF;
    return '${(bits >> 24) & 0xFF}.${(bits >> 16) & 0xFF}.${(bits >> 8) & 0xFF}.${bits & 0xFF}';
  }
}
