import 'package:lingu/domain/chat/models/feedback/message_feedback_summary.dart';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';

sealed class MessageViewDto {
  final int id;
  const MessageViewDto({required this.id});
}

class UserTextMessageViewDto extends MessageViewDto {
  final UserTextMessageModel chatMessage;
  final TextFeedbackSummary? feedbackSummary;

  UserTextMessageViewDto({
    required this.chatMessage,
    this.feedbackSummary,
  }) : super(id: chatMessage.id);
}

class UserAudioMessageViewDto extends MessageViewDto {
  final UserAudioMessageModel chatMessage;
  final AudioFeedbackSummary? feedbackSummary;

  UserAudioMessageViewDto({
    required this.chatMessage,
    this.feedbackSummary,
  }) : super(id: chatMessage.id);
}

class AITextMessageViewDto extends MessageViewDto {
  final AITextMessageModel chatMessage;
  final String? translation;

  AITextMessageViewDto({
    required this.chatMessage,
    this.translation,
  }) : super(id: chatMessage.id);
}

class AIAudioMessageViewDto extends MessageViewDto {
  final String transcription;
  final String? translation;
  final SpeechAudio speechAudio;

  AIAudioMessageViewDto({
    required super.id,
    required this.transcription,
    required this.speechAudio,
    this.translation,
  });
}
