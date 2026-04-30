import 'package:lingu/domain/word/models/word.dart';

class AIWordResponse<T> {
  final String word;
  final List<AIMeaningResponse<T>> meanings;

  AIWordResponse({required this.word, required this.meanings});
}

class AIMeaningResponse<T> {
  final String meaning;
  final PartOfSpeech partOfSpeech;
  final List<AIExampleResponse> examples;
  final String ssmlAudioPrompt;
  final String imageDescription;
  final String imageCredits;
  final T languageSpecificDetails;

  AIMeaningResponse({
    required this.meaning,
    required this.partOfSpeech,
    required this.examples,
    required this.ssmlAudioPrompt,
    required this.imageDescription,
    required this.imageCredits,
    required this.languageSpecificDetails,
  });
}

class AIExampleResponse {
  final String translation;
  final String example;

  AIExampleResponse({required this.translation, required this.example});
}
