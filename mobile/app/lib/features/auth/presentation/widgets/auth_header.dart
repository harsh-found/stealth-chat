import 'package:flutter/material.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

class AuthHeader extends StatelessWidget {
  final Color accentColor;

  const AuthHeader({super.key, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.shield_rounded,
              color: accentColor,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'Stealth Chat',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        const Center(
          child: Text(
            'Zero-knowledge · Monotonic sync · Neon PostgreSQL',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: StealthColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
