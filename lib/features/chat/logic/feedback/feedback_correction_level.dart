enum FeedbackCorrectionLevel
{
  bad,
  neutral
}

class UserFeedback {
  final FeedbackCorrectionLevel level;
  final String correction;
  final String explanation;

  UserFeedback({
    required this.level,
    required this.correction,
    required this.explanation,
  });

  @override
  String toString() {
    return 'UserFeedback(level: $level, correction: $correction, explanation: $explanation)';
  }
}

class PronunciationFeedback {
  final FeedbackCorrectionLevel level;

  PronunciationFeedback({required this.level});

}