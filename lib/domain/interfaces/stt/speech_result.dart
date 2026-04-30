import 'package:lingu/domain/interfaces/stt/word_detail.dart';

class SpeechResult {
  final String transcript;
  final double confidence;
  final List<WordDetail> words;

  const SpeechResult({
    required this.transcript,
    required this.confidence,
    this.words = const [],
  });
}
