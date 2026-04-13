import 'package:flutter/material.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';
import 'package:lingu/features/chat/ui/widgets/voice_note/voice_note.dart';

class UserVoiceMessage extends StatelessWidget {
  final String audioUrl;
  final Duration duration;
  final FeedbackResultEnum? feedbackResult;
  final String? translation;
  final String? transcription;
  final VoidCallback? onTap;

  const UserVoiceMessage({
    super.key,
    required this.audioUrl,
    required this.duration,
    this.feedbackResult,
    this.translation,
    this.transcription,
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
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceNoteControls(audioUrl: audioUrl, duration: duration),
            if (translation != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  '"$translation"',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
            if (transcription != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  '($transcription)',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black87,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
