import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/message_bubble.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note.dart';

class ChatMessagesList extends StatelessWidget {
  final List<MessageViewDTO> messages;
  final ChatMessagesListController? controller;
  final double maxMessageWidth;
  final double messageSpacing;

  const ChatMessagesList({
    super.key,
    required this.messages,
    this.controller,
    this.maxMessageWidth = 280.0,
    this.messageSpacing = 12.0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isUser = message is UserTextMessageViewDTO || message is UserAudioMessageViewDTO;

        return Padding(
          padding: EdgeInsets.only(bottom: messageSpacing),
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: _MessageItem(
              message: message,
              maxWidth: maxMessageWidth,
              onTap: () => controller?.onMessageTap?.call(message),
            ),
          ),
        );
      },
    );
  }
}

class _MessageItem extends StatelessWidget {
  final MessageViewDTO message;
  final double maxWidth;
  final VoidCallback onTap;

  const _MessageItem({
    required this.message,
    required this.maxWidth,
    required this.onTap,
  });

  bool get _isClickable {
    if (message is UserTextMessageViewDTO) {
      final m = message as UserTextMessageViewDTO;
      if (m.translatedText != null) return true;
      return m.grammarErrorSeverity != null && m.fluencyCorrection != null;
    }
    if (message is UserAudioMessageViewDTO) {
      final m = message as UserAudioMessageViewDTO;
      if (m.translatedText != null) return true;
      return m.grammarErrorSeverity != null &&
          m.fluencyCorrection != null &&
          m.pronunciationErrorSeverity != null;
    }
    return true; // AI messages are clickable by default or as per logic
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message is UserTextMessageViewDTO || message is UserAudioMessageViewDTO;

    return Column(
      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: GestureDetector(
            onTap: _isClickable ? onTap : null,
            child: MessageBubble(content: _buildContent()),
          ),
        ),
        if (isUser) _buildFeedbackInfo(),
      ],
    );
  }

  Widget _buildContent() {
    final msg = message;
    if (msg is UserTextMessageViewDTO) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg.text),
            if (msg.translatedText != null) ...[
              const SizedBox(height: 4),
              Text(
                '"${msg.translatedText!}"',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      );
    } else if (msg is UserAudioMessageViewDTO) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceNote(
              audioUrl: msg.audioUrl,
              duration: msg.duration,
            ),
            if (msg.translatedText != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                child: Text(
                  '"${msg.translatedText!}"',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),
      );
    }
 else if (msg is AITextMessageViewDTO) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(msg.text),
      );
    } else if (msg is AIAudioMessageViewDTO) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: VoiceNote(
          audioUrl: msg.audioUrl,
          duration: msg.duration,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFeedbackInfo() {
    List<String> info = [];
    if (message is UserTextMessageViewDTO) {
      final m = message as UserTextMessageViewDTO;
      if (m.grammarErrorSeverity != null) info.add("Grammar: ${m.grammarErrorSeverity!.name}");
      if (m.fluencyCorrection != null) info.add("Fluency: ${m.fluencyCorrection!.name}");
    } else if (message is UserAudioMessageViewDTO) {
      final m = message as UserAudioMessageViewDTO;
      if (m.pronunciationErrorSeverity != null) info.add("Pronunciation: ${m.pronunciationErrorSeverity!.name}");
      if (m.grammarErrorSeverity != null) info.add("Grammar: ${m.grammarErrorSeverity!.name}");
      if (m.fluencyCorrection != null) info.add("Fluency: ${m.fluencyCorrection!.name}");
    }

    if (info.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: info.map((text) => Text(
          text,
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        )).toList(),
      ),
    );
  }
}
