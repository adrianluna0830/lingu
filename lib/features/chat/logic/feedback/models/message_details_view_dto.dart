import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart';
import 'package:lingu/features/chat/logic/feedback/models/translated_text.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';

sealed class MessageDetailsViewDto {}

class UserTextMessageDetailsViewDto implements MessageDetailsViewDto {
  final TranslatedText? translatedText;
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;

  UserTextMessageDetailsViewDto({
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
  });
}

class UserAudioMessageDetailsViewDto implements MessageDetailsViewDto {
  final TranslatedText? translatedText;

  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;
  final PronunciationFeedback? pronunciationFeedback;

  UserAudioMessageDetailsViewDto({
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
    required this.pronunciationFeedback,
  });
}

class AITextMessageDetailsViewDto implements MessageDetailsViewDto {
  final String? translation;

  AITextMessageDetailsViewDto({required this.translation});
}

class AIAudioMessageDetailsViewDto implements MessageDetailsViewDto {
  final String transcript;
  final String? translation;

  AIAudioMessageDetailsViewDto({required this.transcript, required this.translation});
}
