import 'package:lingu/features/chat/ui/chat_messages_list/models/feedback_result_enum.dart';

sealed class MessageViewDTO {
  final int id;
  MessageViewDTO({required this.id});
}

class UserTextMessageViewDTO extends MessageViewDTO {
  final String text;
  final String? correction;
  final String? translatedText;
  final FeedbackResultEnum? grammarErrorSeverity;
  final FeedbackResultEnum? fluencyCorrection;

  UserTextMessageViewDTO({
    required super.id,
    required this.text,
    required this.correction,
    required this.translatedText,
    required this.grammarErrorSeverity,
    required this.fluencyCorrection,
  });
}

class UserAudioMessageViewDTO extends MessageViewDTO {
  final String audioUrl;
  final Duration duration;
  final String? correction;
  final String? translatedText;
  final FeedbackResultEnum? grammarErrorSeverity;
  final FeedbackResultEnum? fluencyCorrection;
  final FeedbackResultEnum? pronunciationErrorSeverity;

  UserAudioMessageViewDTO({
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

class AITextMessageViewDTO extends MessageViewDTO {
  final String text;
  final String? translation;

  AITextMessageViewDTO({
    required super.id,
    required this.text,
    required this.translation,
  });
}

class AIAudioMessageViewDTO extends MessageViewDTO {
  final String audioUrl;
  final Duration duration;
  final String transcript;
  final String? translation;

  AIAudioMessageViewDTO({
    required super.id,
    required this.audioUrl,
    required this.duration,
    required this.transcript,
    required this.translation,
  });
}
