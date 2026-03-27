import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback.dart';

sealed class AudioFeedbackState {
  const AudioFeedbackState();
}

class AnalyzingAudio extends AudioFeedbackState {
  const AnalyzingAudio();
}

class AudioFeedbackResult extends AudioFeedbackState {
  final PronunciationFeedback pronunciation;
  final Feedback? fluency;
  final Feedback? grammar;

  const AudioFeedbackResult({
    required this.pronunciation,
    this.fluency,
    this.grammar,
  });
}
