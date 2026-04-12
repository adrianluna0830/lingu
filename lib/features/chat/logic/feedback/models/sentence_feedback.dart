import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';

class SentenceFeedback {
  final String correction;
  final String explanation;
  final ErrorSeverityEnum severity;

  SentenceFeedback({
    required this.correction,
    required this.explanation,
    required this.severity,
  });

  @override
  String toString() {
    return 'Feedback(severity: $severity, correction: $correction, explanation: $explanation)';
  }
}
