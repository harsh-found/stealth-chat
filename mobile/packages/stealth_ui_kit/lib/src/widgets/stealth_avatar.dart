import 'package:flutter/material.dart';
import '../theme/stealth_colors.dart';

class StealthAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final bool isOnline;

  const StealthAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 46.0,
    this.isOnline = false,
  });

  String _getInitials(String input) {
    if (input.trim().isEmpty) return '?';
    final parts = input.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return input.trim().substring(0, input.trim().length >= 2 ? 2 : 1).toUpperCase();
  }

  Color _hashColor(String str) {
    final colors = [
      const Color(0xFF2563EB),
      const Color(0xFF10B981),
      const Color(0xFF8B5CF6),
      const Color(0xFFF59E0B),
      const Color(0xFF06B6D4),
      const Color(0xFFEC4899),
    ];
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      hash = str.codeUnitAt(i) + ((hash << 5) - hash);
    }
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);
    final bgColor = _hashColor(name);

    return Stack(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor.withValues(alpha: 0.2),
            border: Border.all(color: StealthColors.border, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: size * 0.38,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981),
                shape: BoxShape.circle,
                border: Border.all(color: StealthColors.background, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
