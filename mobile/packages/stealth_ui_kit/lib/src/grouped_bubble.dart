import 'package:flutter/material.dart';
import 'status_ticks.dart';
import 'theme.dart';

enum BubblePosition {
  single,
  first,
  middle,
  last,
}

class GroupedBubble extends StatelessWidget {
  final Widget content;
  final bool isOutgoing;
  final BubblePosition position;
  final String timestampText;
  final MessageTickStatus? status;
  final String? replyAuthor;
  final String? replyText;
  final VoidCallback? onReplyTap;

  const GroupedBubble({
    super.key,
    required this.content,
    required this.isOutgoing,
    this.position = BubblePosition.single,
    required this.timestampText,
    this.status,
    this.replyAuthor,
    this.replyText,
    this.onReplyTap,
  });

  BorderRadius _getBorderRadius() {
    const double r = 18.0;
    const double s = 4.0;

    if (isOutgoing) {
      switch (position) {
        case BubblePosition.single:
          return const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomLeft: Radius.circular(r),
            bottomRight: Radius.circular(s),
          );
        case BubblePosition.first:
          return const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomLeft: Radius.circular(r),
            bottomRight: Radius.circular(s),
          );
        case BubblePosition.middle:
          return const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(s),
            bottomLeft: Radius.circular(r),
            bottomRight: Radius.circular(s),
          );
        case BubblePosition.last:
          return const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(s),
            bottomLeft: Radius.circular(r),
            bottomRight: Radius.circular(r),
          );
      }
    } else {
      switch (position) {
        case BubblePosition.single:
          return const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomLeft: Radius.circular(s),
            bottomRight: Radius.circular(r),
          );
        case BubblePosition.first:
          return const BorderRadius.only(
            topLeft: Radius.circular(r),
            topRight: Radius.circular(r),
            bottomLeft: Radius.circular(s),
            bottomRight: Radius.circular(r),
          );
        case BubblePosition.middle:
          return const BorderRadius.only(
            topLeft: Radius.circular(s),
            topRight: Radius.circular(r),
            bottomLeft: Radius.circular(s),
            bottomRight: Radius.circular(r),
          );
        case BubblePosition.last:
          return const BorderRadius.only(
            topLeft: Radius.circular(s),
            topRight: Radius.circular(r),
            bottomLeft: Radius.circular(r),
            bottomRight: Radius.circular(r),
          );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = StealthTheme.of(context);
    final bgColor = isOutgoing ? theme.outgoingBubble : theme.incomingBubble;

    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: position == BubblePosition.first || position == BubblePosition.single ? 6 : 2,
            bottom: position == BubblePosition.last || position == BubblePosition.single ? 6 : 2,
            left: isOutgoing ? 48 : 12,
            right: isOutgoing ? 12 : 48,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: _getBorderRadius(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (replyText != null && replyText!.isNotEmpty) ...[
                GestureDetector(
                  onTap: onReplyTap,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(6),
                      border: Border(
                        left: BorderSide(
                          color: isOutgoing ? Colors.white70 : theme.accent.color,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (replyAuthor != null)
                          Text(
                            replyAuthor!,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isOutgoing ? Colors.white : theme.accent.lightColor,
                            ),
                          ),
                        Text(
                          replyText!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              content,
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
                  Text(
                    timestampText,
                    style: TextStyle(
                      fontSize: 10,
                      color: isOutgoing
                          ? Colors.white.withValues(alpha: 0.7)
                          : theme.textSecondary,
                    ),
                  ),
                  if (isOutgoing && status != null) ...[
                    const SizedBox(width: 4),
                    MessageStatusTicks(status: status!, size: 13),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
