import 'package:lingu/features/chat/logic/message/user_audio_feedback_process.dart';
import 'package:lingu/features/chat/logic/message/user_text_feedback_process.dart';

sealed class ChatMessage {}

class UserTextMessage extends ChatMessage
{
  final String text;
  final UserTextFeedbackProgress feedbackProcess;
  UserTextMessage({required this.text, this.feedbackProcess = const AnalyzingText()});
}
class UserAudioMessage extends ChatMessage
{
  final String audioUrl;
  final Duration duration;
  final UserAudioFeedbackProgress feedbackProcess;

  UserAudioMessage({required this.audioUrl, required this.duration, this.feedbackProcess = const AnalyzingAudio()});

}
class AITextMessage extends ChatMessage
{
  final String text;
  AITextMessage({required this.text});
}
class AIAudioMessage extends ChatMessage
{
  final String audioUrl;
  final Duration duration;

  AIAudioMessage({required this.audioUrl, required this.duration});
}
