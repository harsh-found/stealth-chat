import 'package:flutter/material.dart';
import '../theme/stealth_colors.dart';

class WaveformWidget extends StatelessWidget {
  final List<int> amplitudes;
  final double progress; // 0.0 to 1.0
  final Color activeColor;
  final Color inactiveColor;
  final ValueChanged<double>? onSeek;

  const WaveformWidget({
    super.key,
    required this.amplitudes,
    this.progress = 0.0,
    this.activeColor = StealthColors.accentElectricBlue,
    this.inactiveColor = const Color(0xFF4B5563),
    this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: onSeek == null
              ? null
              : (details) {
                  final p = (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
                  onSeek!(p);
                },
          child: CustomPaint(
            size: Size(constraints.maxWidth, 28),
            painter: _WaveformPainter(
              amplitudes: amplitudes.isEmpty ? _defaultAmplitudes : amplitudes,
              progress: progress,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
            ),
          ),
        );
      },
    );
  }

  static const List<int> _defaultAmplitudes = [
    15,
    30,
    45,
    60,
    40,
    25,
    55,
    75,
    90,
    80,
    65,
    45,
    30,
    50,
    70,
    85,
    60,
    40,
    35,
    50,
    75,
    95,
    65,
    40,
    30,
    55,
    70,
    45,
    35,
    20,
    15,
    10
  ];
}

class _WaveformPainter extends CustomPainter {
  final List<int> amplitudes;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _WaveformPainter({
    required this.amplitudes,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (amplitudes.isEmpty) return;

    const barWidth = 2.4;
    const spacing = 1.8;
    final totalBars = amplitudes.length;
    final totalWidth = totalBars * (barWidth + spacing) - spacing;

    final startX =
        (size.width - totalWidth) / 2 > 0 ? (size.width - totalWidth) / 2 : 0.0;
    final centerY = size.height / 2;

    final activePaint = Paint()
      ..color = activeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    for (int i = 0; i < totalBars; i++) {
      final x = startX + i * (barWidth + spacing);
      if (x > size.width) break;

      final amp = amplitudes[i].clamp(8, 100);
      final barHeight = (amp / 100.0) * (size.height - 4);
      final isPlayed = (x / size.width) <= progress;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        isPlayed ? activePaint : inactivePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.amplitudes != amplitudes;
  }
}
