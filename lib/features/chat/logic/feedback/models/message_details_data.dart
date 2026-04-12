import 'package:lingu/features/chat/logic/feedback/models/pronunciation_analysis_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';

sealed class MessageDetailsData {}

class UserTextMessageData implements MessageDetailsData {
  final String? translatedText;
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;

  UserTextMessageData({
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
  });
}

class UserAudioMessageData implements MessageDetailsData {
    final String? translatedText;

  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;
  final PronunciationAnalysisResult? pronunciationFeedback;

  UserAudioMessageData({
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
    required this.pronunciationFeedback,
  });
}

class AITextMessageData implements MessageDetailsData {
  final String? translation;

  AITextMessageData({required this.translation});
}

class AIAudioMessageData implements MessageDetailsData {
  final String transcript;
  final String? translation;

  AIAudioMessageData({required this.transcript, required this.translation});
}
