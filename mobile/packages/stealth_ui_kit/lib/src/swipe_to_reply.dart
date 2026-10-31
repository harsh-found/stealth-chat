import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';

class SwipeToReply extends StatefulWidget {
  final Widget child;
  final VoidCallback onReply;
  final bool enabled;

  const SwipeToReply({
    super.key,
    required this.child,
    required this.onReply,
    this.enabled = true,
  });

  @override
  State<SwipeToReply> createState() => _SwipeToReplyState();
}

class _SwipeToReplyState extends State<SwipeToReply>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _dragOffset = 0.0;
  bool _hapticFired = false;
  static const double _triggerThreshold = 55.0;
  static const double _maxDrag = 85.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    )..addListener(() {
        setState(() {
          _dragOffset = _animation.value;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    if (!widget.enabled) return;
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;
    if (_controller.isAnimating) {
      _controller.stop();
    }

    // Swipe right to reply
    final delta = details.primaryDelta ?? 0;
    if (delta > 0 || _dragOffset > 0) {
      setState(() {
        _dragOffset = (_dragOffset + delta * 0.7).clamp(0.0, _maxDrag);
      });

      if (_dragOffset >= _triggerThreshold && !_hapticFired) {
        _hapticFired = true;
        HapticFeedback.lightImpact();
      } else if (_dragOffset < _triggerThreshold) {
        _hapticFired = false;
      }
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;

    if (_dragOffset >= _triggerThreshold) {
      widget.onReply();
    }

    _hapticFired = false;
    _animation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = StealthTheme.of(context);
    final progress = (_dragOffset / _triggerThreshold).clamp(0.0, 1.0);

    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (_dragOffset > 0)
            Positioned(
              left: 12 + (_dragOffset * 0.2),
              child: Opacity(
                opacity: progress,
                child: Transform.scale(
                  scale: 0.6 + (0.4 * progress),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: theme.surfaceSubtle,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.accent.color.withValues(alpha: progress),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.reply_rounded,
                      size: 18,
                      color: theme.accent.color,
                    ),
                  ),
                ),
              ),
            ),
          Transform.translate(
            offset: Offset(_dragOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
