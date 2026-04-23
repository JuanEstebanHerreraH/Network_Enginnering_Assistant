/// AppRouter v3 — uses ShellRoute for persistent navigation.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/shell_screen.dart';
import 'screens/home_screen.dart';
import 'screens/addressing/addressing_screen.dart';
import 'screens/addressing/ipv4_subnet_screen.dart';
import 'screens/addressing/ipv6_screen.dart';
import 'screens/addressing/vlsm_screen.dart';
import 'screens/addressing/subnet_hops_screen.dart';
import 'screens/designer/designer_screen.dart';
import 'screens/designer/vlan_planner_screen.dart';
import 'screens/designer/router_on_stick_screen.dart';
import 'screens/routing/routing_screen.dart';
import 'screens/routing/static_route_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/services/nat_planner_screen.dart';
import 'screens/services/acl_builder_screen.dart';
import 'screens/learning/learning_screen.dart';
import 'screens/tutorials/tutorials_screen.dart';
import 'screens/tutorials/equipment_detail_screen.dart';
import 'screens/tutorials/guide_screen.dart';

class AppRouter {
  static final _rootKey = GlobalKey<NavigatorState>();
  static final _shellKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => ShellScreen(
          currentLocation: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(path: '/', name: 'home', pageBuilder: _fade((_,__) => const HomeScreen())),

          // Addressing
          GoRoute(path: '/addressing', pageBuilder: _fade((_,__) => const AddressingScreen()), routes: [
            GoRoute(path: 'ipv4', pageBuilder: _fade((_,__) => const IPv4SubnetScreen())),
            GoRoute(path: 'ipv6', pageBuilder: _fade((_,__) => const IPv6Screen())),
            GoRoute(path: 'vlsm', pageBuilder: _fade((_,__) => const VlsmScreen())),
            GoRoute(path: 'hops', pageBuilder: _fade((_,__) => const SubnetHopsScreen())),
          ]),

          // Designer
          GoRoute(path: '/designer', pageBuilder: _fade((_,__) => const DesignerScreen()), routes: [
            GoRoute(path: 'vlans', pageBuilder: _fade((_,__) => const VlanPlannerScreen())),
            GoRoute(path: 'router-on-stick', pageBuilder: _fade((_,__) => const RouterOnStickScreen())),
          ]),

          // Routing
          GoRoute(path: '/routing', pageBuilder: _fade((_,__) => const RoutingScreen()), routes: [
            GoRoute(path: 'static', pageBuilder: _fade((_,__) => const StaticRouteScreen())),
          ]),

          // Services
          GoRoute(path: '/services', pageBuilder: _fade((_,__) => const ServicesScreen()), routes: [
            GoRoute(path: 'nat', pageBuilder: _fade((_,__) => const NatPlannerScreen())),
            GoRoute(path: 'acl', pageBuilder: _fade((_,__) => const AclBuilderScreen())),
          ]),

          // Learning
          GoRoute(path: '/learning', pageBuilder: _fade((_,__) => const LearningScreen())),

          // Tutorials
          GoRoute(path: '/tutorials', pageBuilder: _fade((_,__) => const TutorialsScreen()), routes: [
            GoRoute(
              path: 'equipment/:id',
              pageBuilder: (context, state) => _fadeTransition(
                EquipmentDetailScreen(equipmentId: state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              path: 'guide/:id',
              pageBuilder: (context, state) => _fadeTransition(
                GuideScreen(guideId: state.pathParameters['id']!),
              ),
            ),
          ]),
        ],
      ),
    ],
  );

  static Page<void> Function(BuildContext, GoRouterState) _fade(
      Widget Function(BuildContext, GoRouterState) builder) {
    return (context, state) => _fadeTransition(builder(context, state));
  }

  static CustomTransitionPage<void> _fadeTransition(Widget child) {
    return CustomTransitionPage<void>(
      child: child,
      transitionsBuilder: (context, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
      transitionDuration: const Duration(milliseconds: 180),
    );
  }
}
