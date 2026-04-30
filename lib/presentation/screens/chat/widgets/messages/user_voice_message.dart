import 'package:flutter/material.dart';
import 'package:lingu/presentation/ui_utils.dart';
import 'package:lingu/domain/chat/models/enums/feedback_result_enum.dart';
import 'package:lingu/presentation/screens/chat/widgets/messages/message_layout.dart';
import 'package:lingu/presentation/screens/chat/components/input/voice_note_controls.dart';

class UserVoiceMessage extends StatelessWidget {
  final String audioUrl;
  final Duration duration;
  final FeedbackResultEnum? feedbackResult;
  final String? translation;
  final String? transcription;
  final VoidCallback? onTap;
  final VoidCallback? onWordInfo;
  final VoidCallback? onChat;

  const UserVoiceMessage({
    super.key,
    required this.audioUrl,
    required this.duration,
    this.feedbackResult,
    this.translation,
    this.transcription,
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
        VoiceNoteControls(audioUrl: audioUrl, duration: duration),
        if (translation != null && translation!.trim().isNotEmpty)
          MessageSubText('"$translation"'),
        if (transcription != null && transcription!.trim().isNotEmpty)
          MessageSubText('($transcription)'),
      ],
    );
  }
}
