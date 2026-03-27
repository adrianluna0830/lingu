import 'package:lingu/features/chat/logic/feedback/models/feedback.dart';

sealed class TextFeedbackState {
  const TextFeedbackState();
}

class AnalyzingText extends TextFeedbackState {
  const AnalyzingText();
}

class TextFeedbackResult extends TextFeedbackState {
  final Feedback? fluency;
  final Feedback? grammar;

  const TextFeedbackResult({
    this.fluency,
    this.grammar,
  });
}
