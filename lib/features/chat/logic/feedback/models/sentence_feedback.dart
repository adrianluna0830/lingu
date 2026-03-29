class SentenceFeedback {
  final String? correction;
  final String? explanation;

  SentenceFeedback({
    this.correction,
    this.explanation,
  });

  @override
  String toString() {
    return 'Feedback(correction: $correction, explanation: $explanation)';
  }
}
