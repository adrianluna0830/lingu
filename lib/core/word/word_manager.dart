import 'dart:convert';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/word/ai_word_response.dart';
import 'package:lingu/core/word/word_prompts.dart';
import 'package:lingu/core/word/word_repository.dart';
import 'package:lingu/core/word/english_word_details.dart';
import 'package:lingu/core/word/german_word_details.dart';
import 'package:lingu/core/word/spanish_word_details.dart';
import 'package:lingu/core/word/word.dart';

abstract class IWordManager<T extends Word, D> {
  final IAIService _aiService;
  final ITextToSpeechService _ttsService;
  final IAudioUtils _audioUtils;
  final WordRepository _wordRepository;

  IWordManager(this._aiService, this._ttsService, this._audioUtils, this._wordRepository);

  LanguageLocale get _learningLocale;

  D _detailsFromJson(Map<String, dynamic> json);
  T _createWord(String word, List<WordMeaning> meanings);

  Future<T> fetchWord(String word, {required String wordInContext, required LanguageLocale nativeLocale}) async {
    final lemmatizePrompt = 'Extract the lemmatized (base) form of the word highlighted in the following context: "$wordInContext". Return ONLY the base word as a single string, in lowercase, without any additional text or punctuation.';
    final lemmatizedResponse = await _aiService.generateContent(prompt: lemmatizePrompt);
    final baseWord = lemmatizedResponse.trim().toLowerCase();

    assert(baseWord.isNotEmpty, 'Word cannot be empty or contain only spaces.');
    assert(!baseWord.contains(' '), 'Must be a single word without internal spaces.');

    final cachedWord = await _wordRepository.get(baseWord);
    if (cachedWord != null) return cachedWord as T;

    final (prompt, schemaString) = WordPrompts.generateWordRequest(_learningLocale, nativeLocale, baseWord);
    final responseSchema = jsonDecode(schemaString) as Map<String, dynamic>;

    final response = await _aiService.generateContent(prompt: prompt, responseSchema: responseSchema);
    final json = jsonDecode(response) as Map<String, dynamic>;

    final wordObj = await _mapAIResponse(json, nativeLocale);
    await _wordRepository.put(wordObj);

    return wordObj;
  }

  Future<T> _mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale);

  Future<T> _processAIResponse(Map<String, dynamic> json) async {
    final aiResponse = AIWordResponse<D>.fromJson(json, _detailsFromJson);
    final List<WordMeaning> meanings = [];

    for (final m in aiResponse.meanings) {
      final wordAudioBytes = await _ttsService.synthesizeSpeechSSML(ssml: m.ssmlAudioPrompt, voiceName: null, speechBcp47: _learningLocale.bcp47, speakingRate: 1);
      final wordAudioPath = await _audioUtils.saveToPath(wordAudioBytes, true);

      final List<WordExample> examples = [];
      for (final e in m.examples) {
        final exampleAudioBytes = await _ttsService.synthesizeSpeechText(text: e.example, voiceName: null, speechBcp47: _learningLocale.bcp47, speakingRate: 1);
        final exampleAudioPath = await _audioUtils.saveToPath(exampleAudioBytes, true);

        examples.add(WordExample(translation: e.translation, example: e.example, exampleAudioPath: exampleAudioPath));
      }

      meanings.add(
        WordMeaning(
          meaning: m.meaning,
          partOfSpeech: m.partOfSpeech,
          examples: examples,
          wordPronunciationAudioPath: wordAudioPath,
          imagePath: '',
          languageSpecificDetails: m.languageSpecificDetails as dynamic,
        ),
      );
    }

    return _createWord(aiResponse.word, meanings);
  }
}

class EnglishWordManager extends IWordManager<EnglishWord, EnglishWordDetails> {
  EnglishWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository);

  @override
  LanguageLocale get _learningLocale => LanguageLocale.en;

  @override
  EnglishWordDetails _detailsFromJson(Map<String, dynamic> json) => EnglishWordDetails.fromJson(json);

  @override
  EnglishWord _createWord(String word, List<WordMeaning> meanings) => EnglishWord(word: word, meanings: meanings);

  @override
  Future<EnglishWord> _mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return _processAIResponse(json);
  }
}

class GermanWordManager extends IWordManager<GermanWord, GermanWordDetails> {
  GermanWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository);

  @override
  LanguageLocale get _learningLocale => LanguageLocale.de;

  @override
  GermanWordDetails _detailsFromJson(Map<String, dynamic> json) => GermanWordDetails.fromJson(json);

  @override
  GermanWord _createWord(String word, List<WordMeaning> meanings) => GermanWord(word: word, meanings: meanings);

  @override
  Future<GermanWord> _mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return _processAIResponse(json);
  }
}

class SpanishWordManager extends IWordManager<SpanishWord, SpanishWordDetails> {
  SpanishWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository);

  @override
  LanguageLocale get _learningLocale => LanguageLocale.es;

  @override
  SpanishWordDetails _detailsFromJson(Map<String, dynamic> json) => SpanishWordDetails.fromJson(json);

  @override
  SpanishWord _createWord(String word, List<WordMeaning> meanings) => SpanishWord(word: word, meanings: meanings);

  @override
  Future<SpanishWord> _mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return _processAIResponse(json);
  }
}
