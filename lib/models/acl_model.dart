/// AclModel
/// Data model for Access Control List entries.

enum AclAction { permit, deny }
enum AclProtocol { ip, tcp, udp, icmp }
enum AclType { standard, extended }

class AclEntry {
  final AclAction action;
  final AclProtocol protocol;
  final String sourceNetwork;
  final String sourceWildcard;
  final String? destinationNetwork;  // Extended only
  final String? destinationWildcard; // Extended only
  final int? destinationPort;        // Extended only
  final String? description;

  const AclEntry({
    required this.action,
    required this.protocol,
    required this.sourceNetwork,
    required this.sourceWildcard,
    this.destinationNetwork,
    this.destinationWildcard,
    this.destinationPort,
    this.description,
  });
}

class AclModel {
  final int aclNumber;
  final AclType type;
  final String name;
  final List<AclEntry> entries;

  const AclModel({
    required this.aclNumber,
    required this.type,
    required this.name,
    required this.entries,
  });
}
