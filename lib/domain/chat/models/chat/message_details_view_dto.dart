import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:lingu/domain/chat/models/feedback/pronunciation_feedback.dart';
import 'package:lingu/domain/chat/models/chat/translated_text.dart';
import 'package:lingu/domain/chat/models/feedback/sentence_feedback.dart';

sealed class MessageDetails {}

class UserTextDetails implements MessageDetails {
  final TranslatedText? translatedText;
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;

  UserTextDetails({
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
  });
}

class UserAudioDetails implements MessageDetails {
  final String transcription;
  final TranslatedText? translatedText;

  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;
  final PronunciationFeedback? pronunciationFeedback;

  UserAudioDetails({
    required this.transcription,
    required this.translatedText,
    required this.grammarFeedback,
    required this.fluencyFeedback,
    required this.pronunciationFeedback,
  });
}

class SpeechAudio implements MessageDetails {
  final List<SynthesisTimepoint> timepoints;
  final Duration duration;
  final String audioUrl;
  String get sentence => timepoints.map((t) => t.word).join(' ');

  SpeechAudio({
    required this.timepoints,
    required this.duration,
    required this.audioUrl,
  });
}
