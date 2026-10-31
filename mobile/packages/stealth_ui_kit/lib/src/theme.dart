import 'package:flutter/material.dart';

enum StealthAccent {
  electricBlue(
    name: 'Electric Blue',
    color: Color(0xFF2563EB),
    lightColor: Color(0xFF60A5FA),
  ),
  gold(
    name: 'Gold',
    color: Color(0xFFD97706),
    lightColor: Color(0xFFFBBF24),
  ),
  orange(
    name: 'Orange',
    color: Color(0xFFEA580C),
    lightColor: Color(0xFFFB923C),
  ),
  crimson(
    name: 'Crimson',
    color: Color(0xFFDC2626),
    lightColor: Color(0xFFF87171),
  ),
  emerald(
    name: 'Emerald',
    color: Color(0xFF059669),
    lightColor: Color(0xFF34D399),
  );

  final String name;
  final Color color;
  final Color lightColor;

  const StealthAccent({
    required this.name,
    required this.color,
    required this.lightColor,
  });
}

class StealthColors {
  const StealthColors._();

  static const Color background = Color(0xFF101010);
  static const Color surface = Color(0xFF1C1C1C);
  static const Color surfaceSubtle = Color(0xFF242424);
  static const Color surfaceLight = Color(0xFF242424);
  static const Color border = Color(0xFF262626);
  static const Color incomingBubble = Color(0xFF262626);
  static const Color bubbleIncoming = Color(0xFF262626);
  static const Color bubbleOutgoingDefault = Color(0xFF2563EB);
  static const Color textPrimary = Color(0xFFEDEDED);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textMuted = Color(0xFF71717A);
  static const Color divider = Color(0xFF27272A);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color accentElectricBlue = Color(0xFF2563EB);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentPurple = Color(0xFF8B5CF6);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentCrimson = Color(0xFFEF4444);

  static const List<Color> accentPresets = [
    accentElectricBlue,
    accentEmerald,
    accentPurple,
    accentAmber,
    accentCrimson,
  ];
}

class StealthThemeData {
  final StealthAccent accent;
  final Color background;
  final Color surface;
  final Color surfaceSubtle;
  final Color incomingBubble;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color divider;

  Color get outgoingBubble => accent.color;

  const StealthThemeData({
    this.accent = StealthAccent.electricBlue,
    this.background = StealthColors.background,
    this.surface = StealthColors.surface,
    this.surfaceSubtle = StealthColors.surfaceSubtle,
    this.incomingBubble = StealthColors.incomingBubble,
    this.textPrimary = StealthColors.textPrimary,
    this.textSecondary = StealthColors.textSecondary,
    this.textMuted = StealthColors.textMuted,
    this.divider = StealthColors.divider,
  });

  ThemeData toFlutterTheme() {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: background,
      primaryColor: accent.color,
      colorScheme: ColorScheme.dark(
        surface: surface,
        primary: accent.color,
        secondary: accent.lightColor,
        error: StealthColors.error,
        onSurface: textPrimary,
        outline: StealthColors.border,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      dividerColor: divider,
    );
  }
}

class StealthTheme extends InheritedWidget {
  final StealthThemeData data;

  const StealthTheme({
    super.key,
    required this.data,
    required super.child,
  });

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

  static StealthThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<StealthTheme>();
    return widget?.data ?? const StealthThemeData();
  }

  @override
  bool updateShouldNotify(StealthTheme oldWidget) => data != oldWidget.data;
}
