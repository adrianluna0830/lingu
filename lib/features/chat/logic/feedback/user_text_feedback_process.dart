import 'package:lingu/features/chat/logic/message/feedback_correction_level.dart';

sealed class UserTextFeedbackProgress {
  const UserTextFeedbackProgress();
}
class AnalyzingText extends UserTextFeedbackProgress{
  const AnalyzingText();
}

class TextFeedbackResult extends UserTextFeedbackProgress
{
  final UserFeedback? feedback;
  final UserFeedback? grammar;

  TextFeedbackResult({this.feedback, this.grammar});

  
}
