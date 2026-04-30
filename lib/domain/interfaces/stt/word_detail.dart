class WordDetail {
  final String word;
  final double confidence;
  final Duration? startTime;
  final Duration? endTime;

  const WordDetail({
    required this.word,
    required this.confidence,
    this.startTime,
    this.endTime,
  });
}
