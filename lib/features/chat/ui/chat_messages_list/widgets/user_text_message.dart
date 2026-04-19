import 'package:flutter/material.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';

class UserTextMessage extends StatelessWidget {
  final String text;
  final FeedbackResultEnum? feedbackResult;
  final String? translation;
  final VoidCallback? onTap;
  final VoidCallback? onWordInfo;
  final VoidCallback? onChat;

  const UserTextMessage({
    super.key,
    required this.text,
    this.feedbackResult,
    this.translation,
    this.onTap,
    this.onWordInfo,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return MessageLayout(
      isUser: true,
      onLongPress: feedbackResult != null ? onTap : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: feedbackResult != null
            ? [
                BoxShadow(
                  color: getShadowColor(feedbackResult),
                  offset: const Offset(2.4, 2.4),
                  blurRadius: 0,
                ),
              ]
            : null,
      ),
      children: [
        Text(text),
        if (translation != null && translation!.trim().isNotEmpty)
          MessageSubText('"$translation"'),
      ],
    );
  }
}
