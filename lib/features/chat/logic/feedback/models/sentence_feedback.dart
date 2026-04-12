import 'package:googleai_dart/googleai_dart.dart';
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

  static Schema get schema => Schema(
        type: SchemaType.object,
        properties: {
          'correction': Schema(type: SchemaType.string),
          'explanation': Schema(type: SchemaType.string),
          'severity': Schema(
            type: SchemaType.string,
            enumValues: ['bad', 'neutral'],
          ),
        },
        nullable: true,
      );

  factory SentenceFeedback.fromJson(Map<String, dynamic> json) {
    return SentenceFeedback(
      correction: json['correction'] as String,
      explanation: json['explanation'] as String,
      severity: ErrorSeverityEnum.values.byName(json['severity'] as String),
    );
  }

  @override
  String toString() {
    return 'Feedback(severity: $severity, correction: $correction, explanation: $explanation)';
  }
}
