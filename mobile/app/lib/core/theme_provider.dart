import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

final accentColorProvider = StateProvider<Color>((ref) {
  return StealthColors.accentElectricBlue;
});

final themeProvider = Provider<ThemeData>((ref) {
  final accent = ref.watch(accentColorProvider);
  return StealthTheme.darkTheme(accentColor: accent);
});

final screenProtectionProvider = StateProvider<bool>((ref) => false);
final biometricLockProvider = StateProvider<bool>((ref) => false);
