enum FeedbackCorrectionLevel
{
  bad,
  neutral
}

sealed class UserFeedback {
  final FeedbackCorrectionLevel level;
  final String correction;
  final String explanation;

  UserFeedback({
    required this.level,
    required this.correction,
    required this.explanation,
  });
}

sealed class PronunciationFeedback {
  final FeedbackCorrectionLevel level;

  PronunciationFeedback({required this.level});

}