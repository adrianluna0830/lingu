import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';

sealed class MessageFeedbackSummary {
  final FeedbackResultEnum result;
  final String? translation;

  const MessageFeedbackSummary({
    required this.result,
    this.translation,
  });
}

class TextFeedbackSummary extends MessageFeedbackSummary {
  const TextFeedbackSummary({
    required super.result,
    super.translation,
  });
}

class AudioFeedbackSummary extends MessageFeedbackSummary {
  final String transcription;

  const AudioFeedbackSummary({
    required super.result,
    required this.transcription,
    super.translation,
  });
}
