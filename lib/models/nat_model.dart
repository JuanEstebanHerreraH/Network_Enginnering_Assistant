/// NatModel
/// Data model for NAT configuration planning.

enum NatType { staticNat, dynamicNat, pat }

class NatModel {
  final NatType type;
  final String insideInterface;
  final String outsideInterface;
  final String? privateIp;       // Static NAT: single private IP
  final String? publicIp;        // Static NAT: single public IP
  final String? poolName;        // Dynamic NAT: pool name
  final String? poolStartIp;     // Dynamic NAT: pool start
  final String? poolEndIp;       // Dynamic NAT: pool end
  final String? aclNumber;       // ACL used to match traffic
  final String? insideNetwork;   // PAT / Dynamic: inside network

  const NatModel({
    required this.type,
    required this.insideInterface,
    required this.outsideInterface,
    this.privateIp,
    this.publicIp,
    this.poolName,
    this.poolStartIp,
    this.poolEndIp,
    this.aclNumber,
    this.insideNetwork,
  });
}
