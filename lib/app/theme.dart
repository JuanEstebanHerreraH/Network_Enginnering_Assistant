/// AppTheme — Visual design system for the Network Engineering Assistant.
/// Refined dark theme with better contrast, depth and visual hierarchy.

import 'package:flutter/material.dart';

class AppTheme {
  // ─── Brand Colors ──────────────────────────────────────────────────────────
  static const Color primaryGreen   = Color(0xFF00D4A8); // brighter teal-green
  static const Color primaryDark    = Color(0xFF0A0F1A); // deeper dark
  static const Color surfaceDark    = Color(0xFF131927); // nav/sidebar
  static const Color cardDark       = Color(0xFF1A2236); // cards
  static const Color cardDark2      = Color(0xFF1E2840); // elevated cards
  static const Color borderDark     = Color(0xFF2A3550); // subtle border
  static const Color borderLight    = Color(0xFF3D4F6E); // visible border
  static const Color textPrimary    = Color(0xFFE8F0FE); // near-white
  static const Color textSecondary  = Color(0xFF8DA3C0); // muted
  static const Color textMuted      = Color(0xFF5A7090); // very muted
  static const Color accentBlue     = Color(0xFF4DA8FF); // link blue
  static const Color accentOrange   = Color(0xFFFF9A3C); // warm orange
  static const Color accentRed      = Color(0xFFFF6B6B); // error red
  static const Color accentPurple   = Color(0xFFB08AFF); // purple
  static const Color accentCyan     = Color(0xFF26D4F0); // cyan
  static const Color codeBackground = Color(0xFF080D18); // code blocks

  // ─── Semantic Colors ───────────────────────────────────────────────────────
  static const Color success  = Color(0xFF00D4A8);
  static const Color warning  = Color(0xFFFF9A3C);
  static const Color danger   = Color(0xFFFF6B6B);
  static const Color info     = Color(0xFF4DA8FF);

  // ─── Dark Theme ────────────────────────────────────────────────────────────
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: primaryDark,
    colorScheme: const ColorScheme.dark(
      primary: primaryGreen,
      secondary: accentBlue,
      surface: surfaceDark,
      onSurface: textPrimary,
      outline: borderDark,
      error: accentRed,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceDark,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
      iconTheme: IconThemeData(color: textSecondary),
    ),
    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: borderDark),
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: surfaceDark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: primaryGreen.withOpacity(0.18),
      elevation: 0,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: surfaceDark,
      indicatorColor: primaryGreen.withOpacity(0.18),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: accentRed),
      ),
      labelStyle: const TextStyle(color: textSecondary, fontSize: 13),
      hintStyle: const TextStyle(color: textMuted, fontSize: 13),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: primaryDark,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.2),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        side: const BorderSide(color: borderLight),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryGreen,
        textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardDark2,
      labelStyle: const TextStyle(color: textPrimary, fontSize: 12),
      side: const BorderSide(color: borderDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
    dividerTheme: const DividerThemeData(color: borderDark, thickness: 1, space: 1),
    iconTheme: const IconThemeData(color: textSecondary, size: 20),
    listTileTheme: const ListTileThemeData(
      tileColor: Colors.transparent,
      iconColor: textSecondary,
      textColor: textPrimary,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? primaryDark : textSecondary),
      trackColor: WidgetStateProperty.resolveWith((s) =>
          s.contains(WidgetState.selected) ? primaryGreen : borderDark),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryGreen,
      unselectedLabelColor: textSecondary,
      indicatorColor: primaryGreen,
      dividerColor: borderDark,
    ),
    textTheme: const TextTheme(
      headlineLarge:  TextStyle(color: textPrimary, fontWeight: FontWeight.bold,  fontSize: 26, letterSpacing: -0.5),
      headlineMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.bold,  fontSize: 20, letterSpacing: -0.3),
      headlineSmall:  TextStyle(color: textPrimary, fontWeight: FontWeight.w600,  fontSize: 17, letterSpacing: -0.2),
      bodyLarge:      TextStyle(color: textPrimary, fontSize: 15, height: 1.5),
      bodyMedium:     TextStyle(color: textSecondary, fontSize: 13, height: 1.5),
      bodySmall:      TextStyle(color: textMuted, fontSize: 11, height: 1.4),
      labelLarge:     TextStyle(color: textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
      labelMedium:    TextStyle(color: textSecondary, fontWeight: FontWeight.w500, fontSize: 12),
    ),
  );

  // ─── Light Theme ───────────────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0, scrolledUnderElevation: 1),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        side: BorderSide(color: Colors.grey.shade200),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );

  // ─── Code style ───────────────────────────────────────────────────────────
  static const TextStyle codeStyle = TextStyle(
    fontFamily: 'monospace', fontSize: 13, color: textPrimary, height: 1.6,
  );
  static const TextStyle codeBoldStyle = TextStyle(
    fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold,
    color: primaryGreen, height: 1.6,
  );
}
