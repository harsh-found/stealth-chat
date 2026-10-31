import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/stealth_colors.dart';
import '../status_ticks.dart';
import 'status_tick.dart';

class StealthChatBubble extends StatefulWidget {
  final String id;
  final bool isMe;
  final String text;
  final String timestamp;
  final MessageDeliveryStatus status;
  final Color accentColor;
  final String? replyAuthor;
  final String? replyText;
  final Widget? mediaWidget;
  final VoidCallback? onSwipeReply;

  const StealthChatBubble({
    super.key,
    required this.id,
    required this.isMe,
    required this.text,
    required this.timestamp,
    this.status = MessageDeliveryStatus.sent,
    this.accentColor = StealthColors.accentElectricBlue,
    this.replyAuthor,
    this.replyText,
    this.mediaWidget,
    this.onSwipeReply,
  });

  @override
  State<StealthChatBubble> createState() => _StealthChatBubbleState();
}

class _StealthChatBubbleState extends State<StealthChatBubble>
    with SingleTickerProviderStateMixin {
  double _dragOffset = 0.0;
  bool _thresholdReached = false;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (widget.onSwipeReply == null) return;
    if (details.primaryDelta! > 0) {
      setState(() {
        _dragOffset =
            (_dragOffset + details.primaryDelta! * 0.45).clamp(0.0, 70.0);
        if (_dragOffset >= 45.0 && !_thresholdReached) {
          _thresholdReached = true;
          HapticFeedback.lightImpact();
        } else if (_dragOffset < 45.0) {
          _thresholdReached = false;
        }
      });
    }
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (widget.onSwipeReply != null && _thresholdReached) {
      widget.onSwipeReply!();
    }
    setState(() {
      _dragOffset = 0.0;
      _thresholdReached = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor =
        widget.isMe ? widget.accentColor : StealthColors.bubbleIncoming;
    final alignment =
        widget.isMe ? Alignment.centerRight : Alignment.centerLeft;

    final borderRadius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(widget.isMe ? 16 : 4),
      bottomRight: Radius.circular(widget.isMe ? 4 : 16),
    );

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Transform.translate(
          offset: Offset(_dragOffset, 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.78,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: widget.isMe
                        ? Colors.white.withValues(alpha: 0.12)
                        : StealthColors.border,
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Reply preview if this message replies to a parent
                      if (widget.replyText != null) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border(
                              left: BorderSide(
                                color: widget.isMe
                                    ? Colors.white70
                                    : widget.accentColor,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.replyAuthor ?? 'Reply',
                                style: TextStyle(
                                  color: widget.isMe
                                      ? Colors.white
                                      : widget.accentColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.replyText!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Optional media widget (e.g., waveform, photo preview)
                      if (widget.mediaWidget != null) ...[
                        widget.mediaWidget!,
                        const SizedBox(height: 4),
                      ],

                      // Message text
                      if (widget.text.isNotEmpty)
                        Text(
                          widget.text,
                          style: const TextStyle(
                            color: StealthColors.textPrimary,
                            fontSize: 15,
                            height: 1.3,
                          ),
                        ),

                      const SizedBox(height: 4),

                      // Timestamp and Status Tick
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Spacer(),
                          Text(
                            widget.timestamp,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          if (widget.isMe) ...[
                            const SizedBox(width: 4),
                            StatusTick(status: widget.status),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
