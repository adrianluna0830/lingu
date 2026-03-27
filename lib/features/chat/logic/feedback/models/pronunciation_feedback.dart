class PronunciationFeedback {
  final String transcript;
  final double accuracyScore;
  final double fluencyScore;
  final double completenessScore;
  final double pronScore;

  PronunciationFeedback({
    required this.transcript,
    required this.accuracyScore,
    required this.fluencyScore,
    required this.completenessScore,
    required this.pronScore,
  });
}
