import 'package:lingu/features/chat/logic/feedback/feedback_correction_level.dart';

sealed class UserAudioFeedbackProgress {
  const UserAudioFeedbackProgress();
}
class AnalyzingAudio extends UserAudioFeedbackProgress {
  const AnalyzingAudio();
}
class GeneratingFeedback extends UserAudioFeedbackProgress {
  const GeneratingFeedback();
}
class AudioFeedbackResult extends UserAudioFeedbackProgress
{
  final String transcription;
  final UserFeedback? feedback;
  final UserFeedback? grammar;
  final PronunciationFeedback? pronunciation;

  AudioFeedbackResult(this.transcription, this.feedback, this.grammar, this.pronunciation);


}
