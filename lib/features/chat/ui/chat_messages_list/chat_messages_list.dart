import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/widgets/voice_note/voice_note.dart';

Color getShadowColor(FeedbackResultEnum? severity) {
  if (severity == null) return Colors.grey[400]!;
  return switch (severity) {
    FeedbackResultEnum.minor => Colors.orange,
    FeedbackResultEnum.major => Colors.red,
    FeedbackResultEnum.none => Colors.green,
  };
}

class ChatMessagesList extends StatelessWidget {
  final List<MessageViewDto> messages;
  final ChatMessagesListController? controller;

  const ChatMessagesList({super.key, required this.messages, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        if (message is UserTextMessageViewDto ||
            message is UserAudioMessageViewDto) {
          final hasFeedback = switch (message) {
            UserTextMessageViewDto m => m.feedbackSummary != null,
            UserAudioMessageViewDto m => m.feedbackSummary != null,
            _ => false,
          };

          return UserMessageItem(
            message: message,
            onTap:
                hasFeedback ? () => controller?.onMessageTap?.call(message) : null,
          );
        }

        return AIMessageItem(
          message: message,
          onTap: () => controller?.onMessageTap?.call(message),
        );
      },
    );
  }
}

class MessageLayout extends StatelessWidget {
  final Alignment alignment;
  final VoidCallback? onLongPress;
  final Widget child;
  final Decoration? decoration;

  const MessageLayout({
    super.key,
    required this.alignment,
    this.onLongPress,
    required this.child,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: Container(
          decoration: decoration,
          child: Material(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(8.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class UserMessageItem extends StatelessWidget {
  final MessageViewDto message;
  final VoidCallback? onTap;

  const UserMessageItem({
    super.key,
    required this.message,
    this.onTap,
  });

  FeedbackResultEnum? get _feedbackSeverity => switch (message) {
        UserTextMessageViewDto m => m.feedbackSummary?.mostSevere,
        UserAudioMessageViewDto m => m.feedbackSummary?.mostSevere,
        _ => null,
      };


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7, left: 7, top: 3, bottom: 6),
      child: MessageLayout(
        alignment: Alignment.centerRight,
        onLongPress: onTap,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: getShadowColor(_feedbackSeverity),
              offset: const Offset(2.4, 2.4),
              blurRadius: 0,
            ),
          ],
        ),
        child: MessageContent(message: message),
      ),
    );
  }
}

class AIMessageItem extends StatelessWidget {
  final MessageViewDto message;
  final VoidCallback? onTap;

  const AIMessageItem({
    super.key,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7, left: 7, top: 3, bottom: 6),
      child: MessageLayout(
        alignment: Alignment.centerLeft,
        onLongPress: onTap,
        child: MessageContent(message: message),
      ),
    );
  }
}

class MessageContent extends StatelessWidget {
  final MessageViewDto message;

  const MessageContent({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final msg = message;

    if (msg is UserTextMessageViewDto) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg.chatMessage.text),
            if (msg.feedbackSummary?.translation != null) ...[
              const SizedBox(height: 4),
              Text(
                '"${msg.feedbackSummary!.translation}"',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (msg is UserAudioMessageViewDto) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceNote(
              audioUrl: msg.chatMessage.fullMergedAudioFilePath,
              duration: msg.chatMessage.duration,
            ),
            if (msg.feedbackSummary?.translation != null) ...[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  '"${msg.feedbackSummary!.translation}"',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (msg is AITextMessageViewDto) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Text(msg.chatMessage.text),
      );
    }

    if (msg is AIAudioMessageViewDto) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: VoiceNote(
          audioUrl: msg.chatMessage.audioUrl,
          duration: msg.chatMessage.duration,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
