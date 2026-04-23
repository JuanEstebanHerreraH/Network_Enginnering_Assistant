/// AclBuilder (core)
/// Generates Cisco IOS ACL command strings from AclModel data.
/// Pure logic — no UI dependencies.

import '../models/acl_model.dart';

class AclBuilderCore {
  AclBuilderCore._();

  /// Generates the full ACL configuration block for a given AclModel.
  static List<String> generateCommands(AclModel acl) {
    final commands = <String>[];

    if (acl.type == AclType.standard) {
      commands.add('ip access-list standard ${acl.aclNumber}');
    } else {
      commands.add('ip access-list extended ${acl.name}');
    }

    for (final entry in acl.entries) {
      commands.add(_buildEntry(entry, acl.type));
    }

    commands.add('! (implicit deny all — last rule)');
    return commands;
  }

  static String _buildEntry(AclEntry entry, AclType type) {
    final action = entry.action.name; // 'permit' or 'deny'

    if (type == AclType.standard) {
      // Standard: only filters by source
      return ' $action ${entry.sourceNetwork} ${entry.sourceWildcard}';
    }

    // Extended: source + destination + protocol + optional port
    final proto = entry.protocol.name; // 'ip', 'tcp', 'udp', 'icmp'
    final src = '${entry.sourceNetwork} ${entry.sourceWildcard}';
    final dst = entry.destinationNetwork != null
        ? '${entry.destinationNetwork} ${entry.destinationWildcard}'
        : 'any';

    final portStr = (entry.destinationPort != null &&
            (entry.protocol == AclProtocol.tcp ||
                entry.protocol == AclProtocol.udp))
        ? ' eq ${entry.destinationPort}'
        : '';

    final desc = entry.description != null ? ' ! ${entry.description}' : '';
    return ' $action $proto $src $dst$portStr$desc';
  }

  /// Generates ACL application commands for an interface.
  static List<String> applyToInterface(
      String interfaceName, int aclNumber, String direction) {
    return [
      'interface $interfaceName',
      ' ip access-group $aclNumber $direction',
    ];
  }

  /// Generates a named extended ACL.
  static List<String> generateNamedAcl(AclModel acl) {
    final commands = <String>[];
    commands.add('ip access-list extended ${acl.name}');
    for (final entry in acl.entries) {
      commands.add(_buildEntry(entry, AclType.extended));
    }
    return commands;
  }

  /// Returns a conceptual explanation of ACL operation.
  static List<String> getExplanation(AclModel acl) {
    return [
      '📋 ACL ${acl.aclNumber} — ${acl.type == AclType.standard ? 'Standard' : 'Extended'}\n'
          '   ACLs filter traffic using a sequential rule list.\n'
          '   Rules are checked top-down; first match wins.',
      if (acl.type == AclType.standard)
        '🔍 Standard ACL Logic\n'
            '   • Filters based on SOURCE IP only\n'
            '   • Apply close to the DESTINATION\n'
            '   • Uses wildcard mask (inverse of subnet mask)',
      if (acl.type == AclType.extended)
        '🔍 Extended ACL Logic\n'
            '   • Filters by source IP, destination IP, protocol, port\n'
            '   • Apply close to the SOURCE\n'
            '   • More granular control than standard ACLs',
      '⚠️  Implicit Deny\n'
          '   Every ACL ends with an implicit "deny any any"\n'
          '   You must explicitly permit all traffic you want to allow.',
    ];
  }
}
