import 'package:lingu/features/chat/logic/message/feedback_correction_level.dart';

sealed class UserTextFeedbackProgress {
  const UserTextFeedbackProgress();
}
class AnalyzingText extends UserTextFeedbackProgress{
  const AnalyzingText();
}
class FluencyIssues
{
  final FeedbackCorrectionLevel level;
  FluencyIssues({required this.level});
}
class TextFeedbackResult extends UserTextFeedbackProgress
{
  final UserFeedback? feedback;
  final UserFeedback? grammar;

  TextFeedbackResult({this.feedback, this.grammar});

  
}
