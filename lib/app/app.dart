import 'package:flutter/material.dart';
import 'routes.dart';
import 'theme.dart';

class NetworkEngineeringApp extends StatelessWidget {
  const NetworkEngineeringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NetRedes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
