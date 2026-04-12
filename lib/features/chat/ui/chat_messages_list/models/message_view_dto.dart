import 'package:lingu/features/chat/ui/chat_messages_list/models/feedback_result_enum.dart';

sealed class MessageViewDto {
  final int id;
  MessageViewDto({required this.id});
}

class UserTextMessageViewDto extends MessageViewDto {
  final String text;
  final String? correction;
  final String? translatedText;
  final FeedbackResultEnum? grammarErrorSeverity;
  final FeedbackResultEnum? fluencyCorrection;

  UserTextMessageViewDto({
    required super.id,
    required this.text,
    required this.correction,
    required this.translatedText,
    required this.grammarErrorSeverity,
    required this.fluencyCorrection,
  });
}

class UserAudioMessageViewDto extends MessageViewDto {
  final String audioUrl;
  final Duration duration;
  final String? correction;
  final String? translatedText;
  final FeedbackResultEnum? grammarErrorSeverity;
  final FeedbackResultEnum? fluencyCorrection;
  final FeedbackResultEnum? pronunciationErrorSeverity;

  UserAudioMessageViewDto({
    required super.id,
    required this.audioUrl,
    required this.duration,
    required this.correction,
    required this.translatedText,
    required this.grammarErrorSeverity,
    required this.fluencyCorrection,
    required this.pronunciationErrorSeverity,
  });
}

class AITextMessageViewDto extends MessageViewDto {
  final String text;
  final String? translation;

  AITextMessageViewDto({
    required super.id,
    required this.text,
    required this.translation,
  });
}

class AIAudioMessageViewDto extends MessageViewDto {
  final String audioUrl;
  final Duration duration;
  final String transcript;
  final String? translation;

  AIAudioMessageViewDto({
    required super.id,
    required this.audioUrl,
    required this.duration,
    required this.transcript,
    required this.translation,
  });
}
