import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';



class TextFeedbackResult  {
  final FeedbackCorrectionLevel? fluency;
  final FeedbackCorrectionLevel? grammar;

  const TextFeedbackResult({
    this.fluency,
    this.grammar,
  });
}
