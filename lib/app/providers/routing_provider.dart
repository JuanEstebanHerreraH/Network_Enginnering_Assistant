/// RoutingProvider
/// Manages state for the Routing Assistant module.

import 'package:flutter/foundation.dart';
import '../../engine/config_generator.dart';
import '../../models/route_model.dart';
import '../../models/nat_model.dart';

class RoutingProvider extends ChangeNotifier {
  // ── Static Routes ──────────────────────────────────────────────────────────
  final List<RouteModel> _routes = [];
  String? _routeConfig;

  List<RouteModel> get routes => List.unmodifiable(_routes);
  String? get routeConfig => _routeConfig;

  void addRoute(RouteModel route) {
    _routes.add(route);
    notifyListeners();
  }

  void removeRoute(int index) {
    _routes.removeAt(index);
    notifyListeners();
  }

  void clearRoutes() {
    _routes.clear();
    _routeConfig = null;
    notifyListeners();
  }

  void generateRouteConfig({String hostname = 'Router'}) {
    if (_routes.isEmpty) return;
    _routeConfig = ConfigGenerator.staticRoutes(
      routes: _routes,
      hostname: hostname,
    );
    notifyListeners();
  }

  // ── NAT ────────────────────────────────────────────────────────────────────
  String? _natConfig;

  String? get natConfig => _natConfig;

  void generateNatConfig(NatModel nat) {
    _natConfig = ConfigGenerator.natConfig(nat);
    notifyListeners();
  }

  void clearNatConfig() {
    _natConfig = null;
    notifyListeners();
  }
}
