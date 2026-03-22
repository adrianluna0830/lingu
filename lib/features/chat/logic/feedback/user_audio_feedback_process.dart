import 'package:lingu/features/chat/logic/feedback/feedback_correction_level.dart';

sealed class AudioFeedbackState {
  const AudioFeedbackState();
}
class AnalyzingAudio extends AudioFeedbackState {
  const AnalyzingAudio();
}
class GeneratingFeedback extends AudioFeedbackState {
  const GeneratingFeedback();
}
class AudioFeedbackResult extends AudioFeedbackState
{
  final String transcription;
  final UserFeedback? feedback;
  final UserFeedback? grammar;
  final PronunciationFeedback? pronunciation;

  AudioFeedbackResult(this.transcription, this.feedback, this.grammar, this.pronunciation);


}