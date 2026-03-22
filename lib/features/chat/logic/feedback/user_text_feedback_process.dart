import 'package:lingu/features/chat/logic/feedback/feedback_correction_level.dart';

sealed class TextFeedbackState {
  const TextFeedbackState();
}
class AnalyzingText extends TextFeedbackState{
  const AnalyzingText();
}

class TextFeedbackResult extends TextFeedbackState
{
  final UserFeedback? feedback;
  final UserFeedback? grammar;

  TextFeedbackResult({required this.feedback, required this.grammar});


  
}