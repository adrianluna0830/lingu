import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_state.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/message_bubble.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note.dart';

class ChatMessagesList extends StatefulWidget {
  final List<ChatMessage> messages;
  final ChatMessagesListController? controller;
  final double maxMessageWidth;
  final double messageSpacing;
  final double iconSize;

  const ChatMessagesList({
    super.key,
    required this.messages,
    this.controller,
    this.maxMessageWidth = 280.0,
    this.messageSpacing = 12.0,
    this.iconSize = 16.0,
  });

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  Color _getFeedbackColor(FeedbackCorrectionLevel? level) {
    if (level == null) return Colors.green;
    return level == FeedbackCorrectionLevel.bad ? Colors.red : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final chatMessage = widget.messages[index];

        return _ChatMessageTile(
          message: chatMessage,
          maxWidth: widget.maxMessageWidth,
          spacing: widget.messageSpacing,
          onLongPress: () =>
              widget.controller?.onMessageTap?.call(chatMessage),
          feedbackIcons: _MessageFeedbackBar(
            message: chatMessage,
            iconSize: widget.iconSize,
            getColor: _getFeedbackColor,
          ),
        );
      },
    );
  }
}

class _ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final double maxWidth;
  final double spacing;
  final Widget feedbackIcons;
  final VoidCallback? onLongPress;

  const _ChatMessageTile({
    required this.message,
    required this.maxWidth,
    required this.spacing,
    required this.feedbackIcons,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing),
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: GestureDetector(
                onLongPress: message.isClickable ? onLongPress : null,
                child: MessageBubble(content: _buildContent()),
              ),
            ),
            if (message.isUser) feedbackIcons,
          ],
        ),
      ),
    );
  }

  Widget _buildContent() => switch (message) {
        UserTextMessage m => TextMessageBubbleContent(text: m.text),
        UserAudioMessage m => VoiceNoteBubbleContent(
            audioUrl: m.fullMergedAudioUrl,
            duration: m.duration,
          ),
        AITextMessage m => TextMessageBubbleContent(text: m.text),
        AIAudioMessage m => VoiceNoteBubbleContent(
            audioUrl: m.audioUrl,
            duration: m.duration,
          ),
      };
}

class _MessageFeedbackBar extends StatelessWidget {
  final ChatMessage message;
  final double iconSize;
  final Color Function(FeedbackCorrectionLevel?) getColor;

  const _MessageFeedbackBar({
    required this.message,
    required this.iconSize,
    required this.getColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget? icons;

    if (message is UserTextMessage) {
      final state = (message as UserTextMessage).feedbackResult;
      icons = switch (state) {
        FeedbackReady(data: final data) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.spellcheck, size: iconSize, color: getColor(data.grammar)),
              const SizedBox(width: 4),
              Icon(Icons.auto_fix_high, size: iconSize, color: getColor(data.fluency)),
            ],
          ),
        FeedbackLoading() => const Text('Analyzing...',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        _ => null,
      };
    } else if (message is UserAudioMessage) {
      final state = (message as UserAudioMessage).feedbackResult;
      icons = switch (state) {
        FeedbackReady(data: final data) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.record_voice_over,
                  size: iconSize, color: getColor(data.pronunciation)),
              const SizedBox(width: 4),
              Icon(Icons.spellcheck, size: iconSize, color: getColor(data.grammar)),
              const SizedBox(width: 4),
              Icon(Icons.auto_fix_high,
                  size: iconSize, color: getColor(data.fluency)),
            ],
          ),
        FeedbackLoading() => const Text('Analyzing...',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        _ => null,
      };
    }

    if (icons == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4, right: 8),
      child: icons,
    );
  }
}

class TextMessageBubbleContent extends StatelessWidget {
  final String text;
  const TextMessageBubbleContent({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(text),
    );
  }
}

class VoiceNoteBubbleContent extends StatelessWidget {
  final String audioUrl;
  final Duration duration;
  const VoiceNoteBubbleContent({
    super.key,
    required this.audioUrl,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
      child: VoiceNote(
        audioUrl: audioUrl,
        duration: duration,
      ),
    );
  }
}
