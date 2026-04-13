import 'package:lingu/features/chat/logic/feedback/models/message_feedback_summary.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';

sealed class MessageViewDto {
  final int id;
  MessageViewDto({required this.id});
}

class UserTextMessageViewDto extends MessageViewDto {
  final UserTextMessage chatMessage;
  final TextFeedbackSummary? feedbackSummary;

  UserTextMessageViewDto({
    required this.chatMessage,
    required this.feedbackSummary,
  }) : super(id: chatMessage.id);
}

class UserAudioMessageViewDto extends MessageViewDto {
  final UserAudioMessage chatMessage;
  final AudioFeedbackSummary? feedbackSummary;

  UserAudioMessageViewDto({
    required this.chatMessage,
    required this.feedbackSummary,
  }) : super(id: chatMessage.id);
}

class AITextMessageViewDto extends MessageViewDto {
  final AITextMessage chatMessage;
  final String? translation;

  AITextMessageViewDto({
    required this.translation,
    required this.chatMessage,
  }) : super(id: chatMessage.id);
}

class AIAudioMessageViewDto extends MessageViewDto {
  final AIAudioMessage chatMessage;
  final String? translation;

  AIAudioMessageViewDto({
    required this.chatMessage,
    required this.translation,
  }) : super(id: chatMessage.id);
}
