/// AddressingProvider
/// Manages state for the Addressing Tools module.
/// Calls core calculators and exposes results to the UI.

import 'package:flutter/foundation.dart';
import '../../core/ipv4_calculator.dart';
import '../../core/ipv6_calculator.dart';
import '../../core/vlsm_calculator.dart';
import '../../models/subnet_result.dart';
import '../../models/vlan_model.dart';

class AddressingProvider extends ChangeNotifier {
  // ── IPv4 State ─────────────────────────────────────────────────────────────
  SubnetResult? _ipv4Result;
  String? _ipv4Error;
  bool _ipv4Loading = false;

  SubnetResult? get ipv4Result => _ipv4Result;
  String? get ipv4Error => _ipv4Error;
  bool get ipv4Loading => _ipv4Loading;

  void calculateIPv4(String ip, int prefix) {
    _ipv4Loading = true;
    _ipv4Error = null;
    notifyListeners();
    try {
      _ipv4Result = IPv4Calculator.calculate(ip.trim(), prefix);
      _ipv4Error = null;
    } catch (e) {
      _ipv4Result = null;
      _ipv4Error = e.toString().replaceFirst('Invalid argument(s): ', '');
    } finally {
      _ipv4Loading = false;
      notifyListeners();
    }
  }

  void clearIPv4() {
    _ipv4Result = null;
    _ipv4Error = null;
    notifyListeners();
  }

  // ── IPv6 State ─────────────────────────────────────────────────────────────
  IPv6SubnetResult? _ipv6Result;
  String? _ipv6Error;

  IPv6SubnetResult? get ipv6Result => _ipv6Result;
  String? get ipv6Error => _ipv6Error;

  void calculateIPv6(String address, int prefix) {
    _ipv6Error = null;
    try {
      _ipv6Result = IPv6Calculator.calculate(address.trim(), prefix);
    } catch (e) {
      _ipv6Result = null;
      _ipv6Error = e.toString().replaceFirst('Invalid argument(s): ', '');
    }
    notifyListeners();
  }

  void clearIPv6() {
    _ipv6Result = null;
    _ipv6Error = null;
    notifyListeners();
  }

  // ── VLSM State ─────────────────────────────────────────────────────────────
  List<VlsmResult>? _vlsmResults;
  String? _vlsmError;
  List<String> _vlsmSteps = [];

  List<VlsmResult>? get vlsmResults => _vlsmResults;
  String? get vlsmError => _vlsmError;
  List<String> get vlsmSteps => _vlsmSteps;

  void calculateVlsm(
      String baseNetwork, int basePrefix, List<VlsmEntry> entries, {bool isSpanish = true}) {
    _vlsmError = null;
    try {
      _vlsmResults =
          VlsmCalculator.calculate(baseNetwork.trim(), basePrefix, entries);
      _vlsmSteps = VlsmCalculator.buildExplanation(
          baseNetwork.trim(), basePrefix, _vlsmResults!, isSpanish: isSpanish);
    } catch (e) {
      _vlsmResults = null;
      _vlsmSteps = [];
      _vlsmError = e.toString().replaceFirst('Invalid argument(s): ', '');
    }
    notifyListeners();
  }

  void clearVlsm() {
    _vlsmResults = null;
    _vlsmError = null;
    _vlsmSteps = [];
    notifyListeners();
  }
}
