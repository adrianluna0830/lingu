import 'package:flutter/material.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';

class UserTextMessage extends StatelessWidget {
  final String text;
  final FeedbackResultEnum? feedbackResult;
  final String? translation;
  final VoidCallback? onTap;

  const UserTextMessage({
    super.key,
    required this.text,
    this.feedbackResult,
    this.translation,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MessageLayout(
      alignment: Alignment.centerRight,
      onLongPress: feedbackResult != null ? onTap : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: getShadowColor(feedbackResult),
            offset: const Offset(2.4, 2.4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text),
            if (translation != null) ...[
              const SizedBox(height: 4),
              Text(
                '"$translation"',
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
