import 'package:flutter/material.dart';
import 'theme.dart';

class WaveformScrubber extends StatelessWidget {
  final List<int> waveform;
  final bool isPlaying;
  final double progress; // 0.0 to 1.0
  final String durationText;
  final VoidCallback onPlayPause;
  final ValueChanged<double>? onSeek;
  final bool isOutgoing;

  const WaveformScrubber({
    super.key,
    required this.waveform,
    required this.isPlaying,
    required this.progress,
    required this.durationText,
    required this.onPlayPause,
    this.onSeek,
    this.isOutgoing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = StealthTheme.of(context);
    final activeColor = isOutgoing ? Colors.white : theme.accent.lightColor;
    final inactiveColor = isOutgoing
        ? Colors.white.withValues(alpha: 0.35)
        : theme.textMuted.withValues(alpha: 0.5);

    // Fallback if waveform is empty
    final samples = waveform.isNotEmpty
        ? waveform
        : List.generate(32, (i) => 20 + ((i * 17) % 60));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onPlayPause,
            iconSize: 32,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
              color: activeColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (onSeek != null) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final local = box.globalToLocal(details.globalPosition);
                  final fraction = (local.dx / box.size.width).clamp(0.0, 1.0);
                  onSeek!(fraction);
                }
              },
              onTapDown: (details) {
                if (onSeek != null) {
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final local = box.globalToLocal(details.globalPosition);
                  final fraction = (local.dx / box.size.width).clamp(0.0, 1.0);
                  onSeek!(fraction);
                }
              },
              child: SizedBox(
                height: 36,
                child: CustomPaint(
                  painter: _WaveformPainter(
                    samples: samples,
                    progress: progress,
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            durationText,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isOutgoing ? Colors.white.withValues(alpha: 0.85) : theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<int> samples;
  final double progress;
  final Color activeColor;
  final Color inactiveColor;

  _WaveformPainter({
    required this.samples,
    required this.progress,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (samples.isEmpty || size.width <= 0 || size.height <= 0) return;

    final barCount = samples.length;
    final totalSpacing = size.width / barCount;
    final barWidth = (totalSpacing * 0.6).clamp(1.5, 4.0);
    final activePaint = Paint()
      ..color = activeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    final inactivePaint = Paint()
      ..color = inactiveColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = barWidth;

    final progressX = size.width * progress;

    for (int i = 0; i < barCount; i++) {
      final x = i * totalSpacing + (totalSpacing / 2);
      final rawAmp = samples[i].clamp(5, 100);
      final barHeight = (rawAmp / 100.0) * size.height * 0.9;
      final yTop = (size.height - barHeight) / 2;
      final yBottom = yTop + barHeight;

      final paint = x <= progressX ? activePaint : inactivePaint;
      canvas.drawLine(Offset(x, yTop), Offset(x, yBottom), paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.samples != samples;
  }
}
