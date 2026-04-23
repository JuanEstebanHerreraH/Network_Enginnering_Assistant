/// DesignerProvider
/// Manages state for the Network Designer module.
/// Builds VLAN lists and generates Cisco configurations.

import 'package:flutter/foundation.dart';
import '../../core/vlan_calculator.dart';
import '../../engine/config_generator.dart';
import '../../models/vlan_model.dart';

class DesignerProvider extends ChangeNotifier {
  // ── VLAN Planner ───────────────────────────────────────────────────────────
  final List<VlanModel> _vlans = [];
  List<String> _overlapWarnings = [];

  List<VlanModel> get vlans => List.unmodifiable(_vlans);
  List<String> get overlapWarnings => List.unmodifiable(_overlapWarnings);
  bool get hasVlans => _vlans.isNotEmpty;

  void addVlan({
    required int vlanId,
    required String name,
    required String networkAddress,
    required int cidrPrefix,
  }) {
    final vlan = VlanCalculator.create(
      vlanId: vlanId,
      name: name,
      networkAddress: networkAddress,
      cidrPrefix: cidrPrefix,
    );
    _vlans.add(vlan);
    _checkOverlaps();
    notifyListeners();
  }

  void removeVlan(int index) {
    _vlans.removeAt(index);
    _checkOverlaps();
    notifyListeners();
  }

  void clearVlans() {
    _vlans.clear();
    _overlapWarnings.clear();
    notifyListeners();
  }

  void _checkOverlaps() {
    _overlapWarnings = VlanCalculator.checkOverlaps(_vlans);
  }

  // ── Router-on-a-Stick config ───────────────────────────────────────────────
  String? _rosConfig;
  String? _switchConfig;
  String _trunkInterface = 'GigabitEthernet0/0';
  String _routerHostname = 'Router';
  String _switchHostname = 'Switch';

  String? get rosConfig => _rosConfig;
  String? get switchConfig => _switchConfig;
  String get trunkInterface => _trunkInterface;
  String get routerHostname => _routerHostname;
  String get switchHostname => _switchHostname;

  void setTrunkInterface(String iface) {
    _trunkInterface = iface;
    notifyListeners();
  }

  void setRouterHostname(String h) {
    _routerHostname = h;
    notifyListeners();
  }

  void setSwitchHostname(String h) {
    _switchHostname = h;
    notifyListeners();
  }

  void generateRouterOnStick() {
    if (_vlans.isEmpty) return;
    _rosConfig = ConfigGenerator.routerOnStick(
      trunkInterface: _trunkInterface,
      vlans: _vlans,
      hostname: _routerHostname,
    );
    _switchConfig = ConfigGenerator.switchVlanConfig(
      vlans: _vlans,
      trunkPort: 'GigabitEthernet0/24',
      hostname: _switchHostname,
    );
    notifyListeners();
  }

  void clearGeneratedConfig() {
    _rosConfig = null;
    _switchConfig = null;
    notifyListeners();
  }
}
