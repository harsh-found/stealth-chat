import 'package:flutter/material.dart';
import 'package:stealth_ui_kit/stealth_ui_kit.dart';
import '../../domain/chat_models.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final ChatMessageItem? replyingTo;
  final VoidCallback onCancelReply;
  final ValueChanged<String> onSend;
  final VoidCallback? onSendVoice;
  final VoidCallback? onStartVoiceRecording;
  final VoidCallback? onStopVoiceRecording;
  final VoidCallback? onCancelVoiceRecording;
  final VoidCallback? onToggleTray;
  final bool isTrayOpen;
  final bool isRecording;
  final List<int> recordingAmplitudes;
  final ValueChanged<bool>? onTypingChanged;
  final Color accentColor;

  const ChatInputBar({
    super.key,
    required this.controller,
    this.replyingTo,
    required this.onCancelReply,
    required this.onSend,
    this.onSendVoice,
    this.onStartVoiceRecording,
    this.onStopVoiceRecording,
    this.onCancelVoiceRecording,
    this.onToggleTray,
    this.isTrayOpen = false,
    this.isRecording = false,
    this.recordingAmplitudes = const [],
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
      setState(() => _hasText = hasContent);
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

  void _handleVoice() {
    if (widget.onStartVoiceRecording != null) {
      widget.onStartVoiceRecording!();
    } else if (widget.onSendVoice != null) {
      widget.onSendVoice!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: StealthColors.surface,
        border:
            Border(top: BorderSide(color: StealthColors.border, width: 0.8)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reply Preview Banner
            if (widget.replyingTo != null) _buildReplyBanner(),

            // Recording or Input Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child:
                  widget.isRecording ? _buildRecordingBar() : _buildInputRow(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyBanner() {
    final reply = widget.replyingTo!;
    final author = reply.isMe ? 'You' : (reply.replyAuthor ?? 'Sender');
    final text = reply.text.isNotEmpty ? reply.text : '[Media/Voice Note]';

    return Container(
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
                  author,
                  style: TextStyle(
                    color: widget.accentColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded,
                size: 20, color: Colors.white54),
            onPressed: widget.onCancelReply,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingBar() {
    return Row(
      children: [
        const Icon(Icons.fiber_manual_record,
            color: Colors.redAccent, size: 18),
        const SizedBox(width: 6),
        const Text(
          'Recording...',
          style: TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: WaveformWidget(
            amplitudes: widget.recordingAmplitudes.isNotEmpty
                ? widget.recordingAmplitudes
                : [30, 60, 45, 80, 55, 90, 70, 40],
            progress: 1.0,
            activeColor: widget.accentColor,
            inactiveColor: StealthColors.border,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, color: Colors.white54),
          onPressed: widget.onCancelVoiceRecording,
        ),
        IconButton(
          icon: Icon(Icons.send_rounded, color: widget.accentColor),
          onPressed: widget.onStopVoiceRecording,
        ),
      ],
    );
  }

  Widget _buildInputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          icon: Icon(
            widget.isTrayOpen
                ? Icons.keyboard_rounded
                : Icons.emoji_emotions_outlined,
            size: 24,
            color: widget.isTrayOpen
                ? widget.accentColor
                : StealthColors.textSecondary,
          ),
          onPressed: widget.onToggleTray,
        ),
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
                hintStyle:
                    TextStyle(color: StealthColors.textMuted, fontSize: 15),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _hasText ? _handleSend : _handleVoice,
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
    );
  }
}
