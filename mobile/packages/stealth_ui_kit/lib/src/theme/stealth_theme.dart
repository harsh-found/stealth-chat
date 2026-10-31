import 'package:flutter/material.dart';
import 'stealth_colors.dart';

class StealthTheme {
  static ThemeData darkTheme({Color accentColor = StealthColors.accentElectricBlue}) {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: StealthColors.background,
      primaryColor: accentColor,
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        surface: StealthColors.surface,
        onPrimary: Colors.white,
        onSurface: StealthColors.textPrimary,
        outline: StealthColors.border,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: StealthColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: StealthColors.textPrimary),
        titleTextStyle: TextStyle(
          color: StealthColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: StealthColors.border,
        thickness: 0.8,
        space: 1,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: StealthColors.textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: StealthColors.textPrimary, fontSize: 14),
        bodySmall: TextStyle(color: StealthColors.textSecondary, fontSize: 12),
        labelSmall: TextStyle(color: StealthColors.textMuted, fontSize: 10),
      ),
    );
  }
}
