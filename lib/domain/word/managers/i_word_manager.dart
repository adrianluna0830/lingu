import 'dart:convert';
import 'dart:io' as io;
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/domain/interfaces/image_finder/image_quality.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:lingu/domain/word/repositories/i_word_repository.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/interfaces/audio_utils/i_audio_utils.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/word/models/ai_word_response.dart';
import 'package:lingu/domain/interfaces/image_finder/i_image_finder.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_schema_service.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/scripts/speech_timepoints_manager.dart';

abstract class IWordManager<T extends Word, D> {
  final IAIService _aiService;
  final SpeechTimepointsManager _synthesizeScript;
  final IAudioUtils _audioUtils;
  final IWordRepository _wordRepository;
  final IImageFinder? _imageFinder;

  IWordManager(
    this._aiService,
    ITextToSpeechService ttsService,
    ISpeechToTextService sttService,
    this._audioUtils,
    this._wordRepository,
    this._imageFinder,
  ) : _synthesizeScript = SpeechTimepointsManager(
          ttsService: ttsService,
          sttService: sttService,
        );

  LanguageLocale get learningLocale;
  Map<String, dynamic> get responseSchema;

  D detailsFromJson(Map<String, dynamic> json);
  T createWord(String word, List<WordMeaning> meanings);

  String generatePrompt(String word, LanguageLocale nativeLocale) {
    return '''
  You are an expert lexicographer and language teacher.
  Provide a comprehensive dictionary entry for the word "$word" in ${learningLocale.name}.
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

    final prompt = generatePrompt(baseWord, nativeLocale);
    final response = await _aiService.generateContent(prompt: prompt, responseSchema: responseSchema);
    final json = jsonDecode(response) as Map<String, dynamic>;

    final wordObj = await mapAIResponse(json, nativeLocale);
    await _wordRepository.put(wordObj);

    return wordObj;
  }

  Future<T> mapAIResponse(Map<String, dynamic> json, LanguageLocale nativeLocale);

  Future<T> processAIResponse(Map<String, dynamic> json) async {
    final aiResponse = di<IAiSchemaService>().parseAIWordResponse<D>(json, detailsFromJson);
    final List<WordMeaning> meanings = [];

    for (final m in aiResponse.meanings) {
      final response = await _synthesizeScript.execute(
        text: m.ssmlAudioPrompt,
        languageLocale: learningLocale,
      );
      final wordAudioPath = await _audioUtils.saveToPath(response.audioBytes, true);
      final wordSpeechAudio = SpeechAudio(
        timepoints: response.timepoints,
        duration: response.duration,
        audioUrl: wordAudioPath,
      );

      final List<WordExample> examples = [];
      for (final e in m.examples) {
        final exampleResponse = await _synthesizeScript.execute(
          text: e.example,
          languageLocale: learningLocale,
        );
        final exampleAudioPath = await _audioUtils.saveToPath(exampleResponse.audioBytes, true);
        final exampleSpeechAudio = SpeechAudio(
          timepoints: exampleResponse.timepoints,
          duration: exampleResponse.duration,
          audioUrl: exampleAudioPath,
        );

        examples.add(WordExample(
          translation: e.translation,
          example: e.example,
          speechAudio: exampleSpeechAudio,
        ));
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
          image: wordImage,
          languageSpecificDetails: m.languageSpecificDetails as dynamic,
          speechAudio: wordSpeechAudio,
        ),
      );
    }

    return createWord(aiResponse.word, meanings);
  }
}
