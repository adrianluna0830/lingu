import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';


class AudioFeedbackResult  {
  final FeedbackCorrectionLevel? pronunciation;
  final FeedbackCorrectionLevel? fluency;
  final FeedbackCorrectionLevel? grammar;

  const AudioFeedbackResult({
    required this.pronunciation,
    this.fluency,
    this.grammar,
  });
}
