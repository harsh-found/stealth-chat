import 'package:flutter/material.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../domain/chat_models.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final ChatMessageItem? replyingTo;
  final VoidCallback onCancelReply;
  final ValueChanged<String> onSend;
  final VoidCallback onSendVoice;
  final ValueChanged<bool>? onTypingChanged;
  final Color accentColor;

  const ChatInputBar({
    super.key,
    required this.controller,
    this.replyingTo,
    required this.onCancelReply,
    required this.onSend,
    required this.onSendVoice,
    this.onTypingChanged,
    required this.accentColor,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _hasText = widget.controller.text.trim().isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasContent = widget.controller.text.trim().isNotEmpty;
    if (_hasText != hasContent) {
      setState(() {
        _hasText = hasContent;
      });
      widget.onTypingChanged?.call(hasContent);
    }
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      widget.controller.clear();
      widget.onTypingChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: StealthColors.surface,
        border: const Border(
          top: BorderSide(color: StealthColors.border, width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply Preview Banner
            if (widget.replyingTo != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Colors.black.withValues(alpha: 0.35),
                child: Row(
                  children: [
                    Container(
                      width: 3.5,
                      height: 34,
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.replyingTo!.isMe ? 'You' : (widget.replyingTo!.replyAuthor ?? 'Sender'),
                            style: TextStyle(
                              color: widget.accentColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.replyingTo!.text.isNotEmpty
                                ? widget.replyingTo!.text
                                : '[Voice Note]',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20, color: Colors.white54),
                      onPressed: widget.onCancelReply,
                    ),
                  ],
                ),
              ),
            ],

            // Input Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Attachment button
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline_rounded, size: 26, color: StealthColors.textSecondary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Presigned direct media upload ready (R2/S3)'),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                  ),

                  // Text input field
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: StealthColors.background,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: StealthColors.border, width: 0.8),
                      ),
                      child: TextField(
                        controller: widget.controller,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: const InputDecoration(
                          hintText: 'Stealth Message...',
                          hintStyle: TextStyle(color: StealthColors.textMuted, fontSize: 15),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Morphing Button: Mic or Paperplane
                  GestureDetector(
                    onTap: _hasText ? _handleSend : widget.onSendVoice,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _hasText ? widget.accentColor : StealthColors.surfaceLight,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _hasText ? widget.accentColor : StealthColors.border,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        _hasText ? Icons.send_rounded : Icons.mic_rounded,
                        color: _hasText ? Colors.white : StealthColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
