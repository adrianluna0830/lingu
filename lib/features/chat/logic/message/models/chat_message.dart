import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_state.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_state.dart';
import 'package:lingu/features/chat/logic/message/models/message.dart';

sealed class ChatMessage {
  final Message message;
  ChatMessage(this.message);
}

class UserTextMessage extends ChatMessage {
  final TextFeedbackState feedbackState;
  UserTextMessage(super.message, this.feedbackState);
}

class UserAudioMessage extends ChatMessage {
  final AudioFeedbackState feedbackState;
  final String transcript;
  UserAudioMessage(super.message, this.feedbackState, this.transcript);
}

class AITextMessage extends ChatMessage {
  AITextMessage(super.message);
}

class AIAudioMessage extends ChatMessage {
  final String transcript;
  AIAudioMessage(super.message, this.transcript);
}
