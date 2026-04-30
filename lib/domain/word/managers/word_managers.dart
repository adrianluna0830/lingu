import 'package:lingu/domain/interfaces/ai/i_ai_schema_service.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:lingu/domain/word/managers/i_word_manager.dart';
import 'package:lingu/domain/word/models/ai_word_response.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/word/models/details/english_word_details.dart';
import 'package:lingu/domain/word/models/details/german_word_details.dart';
import 'package:lingu/domain/word/models/details/spanish_word_details.dart';

class EnglishWordManager extends IWordManager<EnglishWord, EnglishWordDetails> {
  EnglishWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository, super.imageFinder);

  @override
  LanguageLocale get learningLocale => LanguageLocale.en;

  @override
  Map<String, dynamic> get responseSchema => di<IAiSchemaService>().getAIWordResponseSchema(
    di<IAiSchemaService>().getEnglishWordDetailsSchema(),
  );

  @override
  EnglishWordDetails detailsFromJson(Map<String, dynamic> json) => EnglishWordDetails.fromJson(json);

  @override
  EnglishWord createWord(String word, List<WordMeaning> meanings) => EnglishWord(word: word, meanings: meanings);

  @override
  Future<EnglishWord> mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return processAIResponse(json);
  }
}

class GermanWordManager extends IWordManager<GermanWord, GermanWordDetails> {
  GermanWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository, super.imageFinder);

  @override
  LanguageLocale get learningLocale => LanguageLocale.de;

  @override
  Map<String, dynamic> get responseSchema => di<IAiSchemaService>().getAIWordResponseSchema(
    di<IAiSchemaService>().getGermanWordDetailsSchema(),
  );

  @override
  GermanWordDetails detailsFromJson(Map<String, dynamic> json) => GermanWordDetails.fromJson(json);

  @override
  GermanWord createWord(String word, List<WordMeaning> meanings) => GermanWord(word: word, meanings: meanings);

  @override
  Future<GermanWord> mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return processAIResponse(json);
  }
}

class SpanishWordManager extends IWordManager<SpanishWord, SpanishWordDetails> {
  SpanishWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository, super.imageFinder);

  @override
  LanguageLocale get learningLocale => LanguageLocale.es;

  @override
  Map<String, dynamic> get responseSchema => di<IAiSchemaService>().getAIWordResponseSchema(
    di<IAiSchemaService>().getSpanishWordDetailsSchema(),
  );

  @override
  SpanishWordDetails detailsFromJson(Map<String, dynamic> json) => SpanishWordDetails.fromJson(json);

  @override
  SpanishWord createWord(String word, List<WordMeaning> meanings) => SpanishWord(word: word, meanings: meanings);

  @override
  Future<SpanishWord> mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return processAIResponse(json);
  }
}
