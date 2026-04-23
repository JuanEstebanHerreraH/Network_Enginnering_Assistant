/// Network Engineering Assistant
/// Entry point of the application.
/// Initializes providers and launches the app.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/providers/addressing_provider.dart';
import 'app/providers/designer_provider.dart';
import 'app/providers/routing_provider.dart';
import 'app/providers/locale_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AddressingProvider()),
        ChangeNotifierProvider(create: (_) => DesignerProvider()),
        ChangeNotifierProvider(create: (_) => RoutingProvider()),
      ],
      child: const NetworkEngineeringApp(),
    ),
  );
}
