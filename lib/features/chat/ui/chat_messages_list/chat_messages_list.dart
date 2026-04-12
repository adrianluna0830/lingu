import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/widgets/message_bubble.dart';
import 'package:lingu/features/chat/ui/widgets/voice_note/voice_note.dart';

class ChatMessagesList extends StatelessWidget {
  final List<MessageViewDto> messages;
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
        final isUser = message is UserTextMessageViewDto || message is UserAudioMessageViewDto;

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
  final MessageViewDto message;
  final double maxWidth;
  final VoidCallback onTap;

  const _MessageItem({
    required this.message,
    required this.maxWidth,
    required this.onTap,
  });

  bool get _isClickable {
    if (message is UserTextMessageViewDto) {
      return (message as UserTextMessageViewDto).messageDetails != null;
    }
    if (message is UserAudioMessageViewDto) {
      return (message as UserAudioMessageViewDto).messageDetails != null;
    }
    if (message is AITextMessageViewDto) {
      return (message as AITextMessageViewDto).messageDetails != null;
    }
    if (message is AIAudioMessageViewDto) {
      return (message as AIAudioMessageViewDto).messageDetails != null;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message is UserTextMessageViewDto || message is UserAudioMessageViewDto;

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
    if (msg is UserTextMessageViewDto) {
      final details = msg.messageDetails;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg.chatMessage.text),
            if (details?.rephrasedText != null) ...[
              const SizedBox(height: 4),
              Text(
                '"${details!.rephrasedText!.targetText}"',
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
    } else if (msg is UserAudioMessageViewDto) {
      final details = msg.messageDetails;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceNote(
              audioUrl: msg.chatMessage.fullMergedAudioFilePath,
              duration: msg.chatMessage.duration,
            ),
            if (details?.rephrasedText != null)
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 4.0),
                child: Text(
                  '"${details!.rephrasedText!.targetText}"',
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
    } else if (msg is AITextMessageViewDto) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(msg.chatMessage.text),
      );
    } else if (msg is AIAudioMessageViewDto) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: VoiceNote(
          audioUrl: msg.chatMessage.audioUrl,
          duration: msg.chatMessage.duration,
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildFeedbackInfo() {
    List<String> info = [];
    if (message is UserTextMessageViewDto) {
      final m = message as UserTextMessageViewDto;
      final details = m.messageDetails;
      if (details != null) {
        if (details.grammarFeedback != null) info.add("Grammar: feedback available");
        if (details.fluencyFeedback != null) info.add("Fluency: feedback available");
      } else {
        info.add("Loading feedback...");
      }
    } else if (message is UserAudioMessageViewDto) {
      final m = message as UserAudioMessageViewDto;
      final details = m.messageDetails;
      if (details != null) {
        if (details.pronunciationFeedback != null) info.add("Pronunciation: feedback available");
        if (details.grammarFeedback != null) info.add("Grammar: feedback available");
        if (details.fluencyFeedback != null) info.add("Fluency: feedback available");
      } else {
        info.add("Loading feedback...");
      }
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
