import 'dart:convert';
import 'dart:io' as io;
import 'package:googleai_dart/googleai_dart.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/word/ai_word_response.dart';
import 'package:lingu/core/image/i_image_finder.dart';
import 'package:lingu/core/word/word_repository.dart';
import 'package:lingu/core/word/word_details/english_word_details.dart';
import 'package:lingu/core/word/word_details/german_word_details.dart';
import 'package:lingu/core/word/word_details/spanish_word_details.dart';
import 'package:lingu/core/word/word.dart';

import 'package:lingu/core/settings/image_credentials_service.dart';

abstract class IWordManager<T extends Word, D> {
  final IAIService _aiService;
  final ITextToSpeechService _ttsService;
  final IAudioUtils _audioUtils;
  final WordRepository _wordRepository;
  final IImageFinder? _imageFinder;

  IWordManager(this._aiService, this._ttsService, this._audioUtils, this._wordRepository, this._imageFinder);

  LanguageLocale get _learningLocale;
  Map<String, dynamic> get _responseSchema;

  D _detailsFromJson(Map<String, dynamic> json);
  T _createWord(String word, List<WordMeaning> meanings);

  String _generatePrompt(String word, LanguageLocale nativeLocale) {
    return '''
  You are an expert lexicographer and language teacher.
  Provide a comprehensive dictionary entry for the word "$word" in ${_learningLocale.name}.
  The user's native language is ${nativeLocale.name}. Use it for the meanings and example translations.
  Include all common meanings, parts of speech, and provide clear example sentences for each meaning.
  Analyze all grammar details required by the schema (like gender, plural forms, irregularity, etc.).
  ''';
  }

  Future<T> fetchWord(String word, {required String wordInContext, required LanguageLocale nativeLocale}) async {
    final lemmatizePrompt =
        'Extract the lemmatized (base) form of the word highlighted in the following context: "$wordInContext". Return ONLY the base word as a single string, in lowercase, without any additional text or punctuation.';
    final lemmatizedResponse = await _aiService.generateContent(prompt: lemmatizePrompt);
    final baseWord = lemmatizedResponse.trim().toLowerCase();

    assert(baseWord.isNotEmpty, 'Word cannot be empty or contain only spaces.');
    assert(!baseWord.contains(' '), 'Must be a single word without internal spaces.');

    final cachedWord = await _wordRepository.get(baseWord);
    if (cachedWord != null) return cachedWord as T;

    final prompt = _generatePrompt(baseWord, nativeLocale);
    final response = await _aiService.generateContent(prompt: prompt, responseSchema: _responseSchema);
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

      WordImage? wordImage;
      final imageFinder = _imageFinder;
      if (imageFinder != null) {
        try {
          print('Attempting to find image for: ${m.imageDescription}');
          final imageResponse = await imageFinder.findImage(m.imageDescription, ImageQuality.medium);
          final directory = await getApplicationDocumentsDirectory();
          final imageFileName = '${DateTime.now().microsecondsSinceEpoch}.jpg';
          final imageFile = io.File(path.join(directory.path, imageFileName));
          await imageFile.writeAsBytes(imageResponse.images.first);
          wordImage = WordImage(imagePath: imageFile.path, imageCredits: m.imageCredits, width: imageResponse.width, height: imageResponse.height);
          print('Successfully extracted image to: ${imageFile.path}');
        } catch (e) {
          print('Failed to find or extract image: $e');
        }
      } else {
        print('Skipping image search: imageFinder is null.');
      }

      meanings.add(
        WordMeaning(
          meaning: m.meaning,
          partOfSpeech: m.partOfSpeech,
          examples: examples,
          wordPronunciationAudioPath: wordAudioPath,
          image: wordImage,
          languageSpecificDetails: m.languageSpecificDetails as dynamic,
        ),
      );
    }

    return _createWord(aiResponse.word, meanings);
  }
}

class EnglishWordManager extends IWordManager<EnglishWord, EnglishWordDetails> {
  EnglishWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository, super.imageFinder);

  @override
  LanguageLocale get _learningLocale => LanguageLocale.en;

  @override
  Map<String, dynamic> get _responseSchema => AIWordResponse.getSchema(
    Schema(
      type: SchemaType.object,
      properties: {'isIrregular': Schema(type: SchemaType.boolean, nullable: true)},
      required: ['isIrregular'],
    ),
  ).toJson();

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
  GermanWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository, super.imageFinder);

  @override
  LanguageLocale get _learningLocale => LanguageLocale.de;

  @override
  Map<String, dynamic> get _responseSchema => AIWordResponse.getSchema(
    Schema(
      type: SchemaType.object,
      properties: {
        'gender': Schema(type: SchemaType.string, enumValues: ['masculine', 'feminine', 'neuter'], nullable: true),
        'pluralForm': Schema(type: SchemaType.string, nullable: true),
        'isSeparable': Schema(type: SchemaType.boolean, nullable: true),
        'separablePrefix': Schema(type: SchemaType.string, nullable: true),
        'genitiveForm': Schema(type: SchemaType.string, nullable: true),
      },
      required: ['gender', 'pluralForm', 'isSeparable', 'separablePrefix', 'genitiveForm'],
    ),
  ).toJson();

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
  SpanishWordManager(super.aiService, super.ttsService, super.audioUtils, super.wordRepository, super.imageFinder);

  @override
  LanguageLocale get _learningLocale => LanguageLocale.es;

  @override
  Map<String, dynamic> get _responseSchema => AIWordResponse.getSchema(
    Schema(
      type: SchemaType.object,
      properties: {
        'gender': Schema(type: SchemaType.string, enumValues: ['masculine', 'feminine'], nullable: true),
        'pluralForm': Schema(type: SchemaType.string, nullable: true),
        'isReflexive': Schema(type: SchemaType.boolean, nullable: true),
        'verbType': Schema(type: SchemaType.string, enumValues: ['regular', 'irregular', 'stemChanging'], nullable: true),
      },
      required: ['gender', 'pluralForm', 'isReflexive', 'verbType'],
    ),
  ).toJson();

  @override
  SpanishWordDetails _detailsFromJson(Map<String, dynamic> json) => SpanishWordDetails.fromJson(json);

  @override
  SpanishWord _createWord(String word, List<WordMeaning> meanings) => SpanishWord(word: word, meanings: meanings);

  @override
  Future<SpanishWord> _mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale) {
    return _processAIResponse(json);
  }
}
