import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';

class Feedback {
  final FeedbackCorrectionLevel level;
  final String? correction;
  final String? explanation;

  Feedback({
    required this.level,
    this.correction,
    this.explanation,
  });

  @override
  String toString() {
    return 'Feedback(level: $level, correction: $correction, explanation: $explanation)';
  }
}
