import 'package:lingu/core/tts/core/synthesis_with_timepoints_response.dart';
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
  final String transcription;
  final TranslatedText? translatedText;

  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;
  final PronunciationFeedback? pronunciationFeedback;

  UserAudioMessageDetailsViewDto({
    required this.transcription,
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
    required this.pronunciationFeedback,
  });
}

class AITextMessageDetailsViewDto implements MessageDetailsViewDto {
  AITextMessageDetailsViewDto();
}

class AIAudioMessageDetailsViewDto implements MessageDetailsViewDto {
  final List<SynthesisTimepoint> timepoints;
  final Duration duration;
  final String audioUrl;
  String get sentence => timepoints.map((t) => t.word).join(' ');

  AIAudioMessageDetailsViewDto({required this.timepoints, required this.duration, required this.audioUrl});

}
