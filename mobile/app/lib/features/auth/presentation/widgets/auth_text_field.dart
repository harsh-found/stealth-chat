import 'package:flutter/material.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onToggleObscure;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: StealthColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: StealthColors.border, width: 0.8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white, fontSize: 14.5),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: StealthColors.textSecondary, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: StealthColors.textSecondary,
                    size: 19,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: StealthColors.textMuted,
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
