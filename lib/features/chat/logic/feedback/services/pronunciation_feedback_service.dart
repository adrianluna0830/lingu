import 'dart:convert';
import 'dart:typed_data';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:lingu/core/pronunciation/models/pronunciation_assessment_dto.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/stt/audio_encoding_enum.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';

class AISyllableResponse {
  final String syllablePlainText;
  final String syllableSSML;
  final (String feedback, ErrorSeverityEnum severity)? feedback;
  AISyllableResponse(this.syllablePlainText, this.syllableSSML, this.feedback);

  factory AISyllableResponse.fromJson(Map<String, dynamic> json) {
    final feedbackMap = json['feedback'] as Map<String, dynamic>?;
    (String, ErrorSeverityEnum)? feedbackTuple;
    if (feedbackMap != null) {
      final feedbackMsg = feedbackMap['feedback'] as String;
      final severityStr = feedbackMap['severity'] as String;
      final severity = severityStr == 'bad' ? ErrorSeverityEnum.bad : ErrorSeverityEnum.neutral;
      feedbackTuple = (feedbackMsg, severity);
    }
    return AISyllableResponse(json['syllablePlainText'] as String, json['syllableSSML'] as String, feedbackTuple);
  }
}

class AIPronunciationResponse {
  final String wordSSML;
  final List<AISyllableResponse> syllableFeedback;
  AIPronunciationResponse({required this.wordSSML, required this.syllableFeedback});

  factory AIPronunciationResponse.fromJson(Map<String, dynamic> json) {
    return AIPronunciationResponse(
      wordSSML: json['wordSSML'] as String,
      syllableFeedback: (json['syllableFeedback'] as List).map((item) => AISyllableResponse.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  static Map<String, dynamic> schema(String nativeLanguageName) => {
    "type": "object",
    "properties": {
      "wordSSML": {"type": "string", "description": "SSML of the word for correct pronunciation."},
      "syllableFeedback": {
        "type": "array",
        "items": {
          "type": "object",
          "properties": {
            "syllablePlainText": {"type": "string", "description": "The syllable in readable normal text (NOT IPA)."},
            "syllableSSML": {"type": "string", "description": "SSML of the syllable to synthesize its correct pronunciation."},
            "feedback": {
              "type": "object",
              "nullable": true,
              "description": "Optional feedback if the syllable was mispronounced.",
              "properties": {
                "feedback": {"type": "string", "description": "Feedback in the user's native language ($nativeLanguageName)."},
                "severity": {
                  "type": "string",
                  "enum": ["bad", "neutral"],
                },
              },
              "required": ["feedback", "severity"],
            },
          },
          "required": ["syllablePlainText", "syllableSSML"],
        },
      },
    },
    "required": ["wordSSML", "syllableFeedback"],
  };
}

class AIOverallPronunciationResponse {
  final String? fluencyFeedback;
  final String? observations;

  AIOverallPronunciationResponse({this.fluencyFeedback, this.observations});

  factory AIOverallPronunciationResponse.fromJson(Map<String, dynamic> json) {
    return AIOverallPronunciationResponse(fluencyFeedback: json['fluencyFeedback'] as String?, observations: json['observations'] as String?);
  }

  static Map<String, dynamic> schema(String nativeLanguageName) => {
    "type": "object",
    "properties": {
      "fluencyFeedback": {
        "type": "string",
        "nullable": true,
        "description":
            "Tips on how to sound more native, overall rhythm or fluency advice. Written in $nativeLanguageName. Null if the pronunciation was very native-like and no major tips are needed.",
      },
      "observations": {
        "type": "string",
        "nullable": true,
        "description":
            "Observations of recurring mistakes across the whole phrase, like struggling with certain syllables, phonemes, diphthongs, etc. Written in $nativeLanguageName. Null if there were no significant recurring mistakes.",
      },
    },
  };
}

class PronunciationFeedbackService {
  final int wordContextSize = 5;
  final int goodPronunciationThreshold = 80;

  final IPronunciationAssessmentService _assessmentService;
  final IAiService _aiModel;
  final ISpeechToTextService _sttService;
  final IAudioUtils _audioUtils;
  final ITextToSpeechService _ttsService;
  final ChatLanguages _languages;
  PronunciationFeedbackService(this._assessmentService, this._aiModel, this._sttService, this._audioUtils, this._languages, this._ttsService);

  String _generatePronunciationPrompt(String word, List<String> syllables, List<String> phonemes, double score) {
    return '''
You are an expert pronunciation coach.
The user is learning ${_languages.target.name} and their native language is ${_languages.native.name}.
They tried to pronounce the word "$word".
The speech recognizer returned these syllables: ${syllables.join(', ')}
And these phonemes: ${phonemes.join(', ')}
The user's overall pronunciation score for this word is $score out of 100.

Please analyze the pronunciation and provide feedback.
Return a structured output with the word's correct SSML and a list of syllable feedback.
For each syllable:
- `syllablePlainText`: The syllable in readable normal text (NOT in IPA, but in standard spelling so the user understands).
- `syllableSSML`: The SSML representation for synthesizing the syllable correctly.
- `feedback`: An object containing the feedback message and severity. The feedback MUST be written in the user's native language (${_languages.native.name}). Make it helpful and concise. If the syllable was pronounced correctly (or the error is negligible), omit the `feedback` property entirely (make it null). The severity should be "bad" or "neutral".
''';
  }

  String _generateOverallFeedbackPrompt(String fullTranscript, String wordDetails) {
    return '''
You are an expert pronunciation coach.
The user is learning ${_languages.target.name} and their native language is ${_languages.native.name}.
They pronounced the following sentence: "$fullTranscript"

Here is the detailed phoneme and syllable breakdown of their pronunciation:
$wordDetails

Based on the ENTIRE phrase, provide:
1. `fluencyFeedback`: Tips on how to sound more native for this phrase (e.g., linking words, rhythm, overall intonation). Only provide this if there is room for noticeable improvement, otherwise leave it null.
2. `observations`: General observations about recurring mispronunciations, difficult combinations, or specific phonemes/syllables the user struggles with across the whole phrase. Leave null if there are no major recurring issues.

Both feedbacks MUST be written in the user's native language (${_languages.native.name}).
''';
  }

  Future<WordPronunciationFeedback> _computeWordFeedback(Uint8List audioBytes, WordResult wordResult) async {
    final userWordPronunciationBytes = await _audioUtils.cut(audioBytes, Duration(milliseconds: wordResult.offset ~/ 10000), Duration(milliseconds: wordResult.duration ~/ 10000));
    final userWordPronunciationFilePath = await _audioUtils.saveToPath(userWordPronunciationBytes, true);

    List<String> syllables = wordResult.syllables?.map((s) => s.syllable).toList() ?? [];
    List<String> spokenPhonemes = wordResult.phonemes?.map((p) => p.phoneme).toList() ?? [];

    final String prompt = _generatePronunciationPrompt(wordResult.word, syllables, spokenPhonemes, wordResult.pronunciationAssessment.accuracyScore);

    final aiResponseText = await _aiModel.generateContent(prompt: prompt, responseSchema: AIPronunciationResponse.schema(_languages.native.name));

    final jsonResponse = jsonDecode(aiResponseText) as Map<String, dynamic>;
    final aiPronunciation = AIPronunciationResponse.fromJson(jsonResponse);

    final correctWordPronunciationBytes = await _ttsService.synthesizeSpeechSSML(ssml: aiPronunciation.wordSSML, voiceName: null, speechBcp47: _languages.target.bcp47, speakingRate: 1);
    final correctPronunciationFilePath = await _audioUtils.saveToPath(correctWordPronunciationBytes, true);

    List<SyllablePronunciationFeedback> finalSyllableFeedbacks = [];
    int index = 0;
    for (var sylRespponse in aiPronunciation.syllableFeedback) {
      SyllableResult? origSyllable;
      if (wordResult.syllables != null && index < wordResult.syllables!.length) {
        origSyllable = wordResult.syllables![index];
      }

      String userSyllablePath = '';
      if (origSyllable != null) {
        final userSyllableBytes = await _audioUtils.cut(audioBytes, Duration(milliseconds: origSyllable.offset ~/ 10000), Duration(milliseconds: origSyllable.duration ~/ 10000));
        userSyllablePath = await _audioUtils.saveToPath(userSyllableBytes, true);
      } else {
        userSyllablePath = userWordPronunciationFilePath;
      }

      final correctSyllableBytes = await _ttsService.synthesizeSpeechSSML(ssml: sylRespponse.syllableSSML, voiceName: null, speechBcp47: _languages.target.bcp47, speakingRate: 1);
      final correctSyllablePath = await _audioUtils.saveToPath(correctSyllableBytes, true);

      BadSyllableFeedback? detail;
      if (sylRespponse.feedback != null) {
        detail = BadSyllableFeedback(feedbackMessage: sylRespponse.feedback!.$1, severity: sylRespponse.feedback!.$2);
      }

      finalSyllableFeedbacks.add(
        SyllablePronunciationFeedback(syllable: sylRespponse.syllablePlainText, userPronunciationFilePath: userSyllablePath, correctPronunciationFilePath: correctSyllablePath, detail: detail),
      );
      index++;
    }

    final bool isBad = wordResult.pronunciationAssessment.accuracyScore < goodPronunciationThreshold;

    return WordPronunciationFeedback(
      word: wordResult.word,
      userPronunciationFilePath: userWordPronunciationFilePath,
      correctPronunciationFilePath: correctPronunciationFilePath,
      syllableFeedback: finalSyllableFeedbacks,
      isBad: isBad,
    );
  }

  Future<(TargetLanguagePronunciationResult, List<WordResult>)> _computeTargetLanguageResult(Uint8List audioBytes) async {
    final rawResponse = await _assessmentService.assessFromWavAsync(wavBytes: audioBytes, language: _languages.target.bcp47);

    List<WordPronunciationFeedback> wordFeedback = [];
    for (var wordResult in rawResponse.nBest.first.words) {
      wordFeedback.add(await _computeWordFeedback(audioBytes, wordResult));
    }

    return (TargetLanguagePronunciationResult(transcript: rawResponse.displayText.trim(), wordFeedback: wordFeedback), rawResponse.nBest.first.words);
  }

  Future<NativeLanguagePronunciationResult> _computeNativeLanguageResult(Uint8List audioBytes) async {
    final res = await _sttService.recognize(audioBytes: audioBytes, encoding: AudioEncodingEnum.linear16, sampleRateHertz: 16000, bcp47ToRecognize: _languages.native.bcp47);
    final transcript = res.transcript;
    return NativeLanguagePronunciationResult(transcript: transcript.trim());
  }

  Future<(String?, String?)> _computeOverallFeedback(List<WordResult> allWords, String fullTranscript) async {
    if (allWords.isEmpty) return (null, null);

    final wordDetails = allWords
        .map((w) {
          final syllables = w.syllables?.map((s) => s.syllable).join('-') ?? '';
          final phonemes = w.phonemes?.map((p) => p.phoneme).join(' ') ?? '';
          return 'Word: "${w.word}", Syllables: [$syllables], Phonemes: [$phonemes], Accuracy: ${w.pronunciationAssessment.accuracyScore}';
        })
        .join('\n');

    final prompt = _generateOverallFeedbackPrompt(fullTranscript, wordDetails);

    final aiResponseText = await _aiModel.generateContent(prompt: prompt, responseSchema: AIOverallPronunciationResponse.schema(_languages.native.name));

    final jsonResponse = jsonDecode(aiResponseText) as Map<String, dynamic>;
    final aiResult = AIOverallPronunciationResponse.fromJson(jsonResponse);

    return (aiResult.fluencyFeedback, aiResult.observations);
  }

  Future<PronunciationFeedback> analyze(List<UserSpeechAudio> audioFiles) async {
    List<PronunciationItemResult> itemResults = [];
    List<WordResult> allTargetWords = [];
    String fullTargetTranscript = "";

    for (var audio in audioFiles) {
      final bytes = await _audioUtils.retrieve(audio.filePath);

      if (!audio.isTargetLanguage) {
        final res = await _computeNativeLanguageResult(bytes);
        itemResults.add(res);
        continue;
      }

      final (targetRes, rawWords) = await _computeTargetLanguageResult(bytes);
      allTargetWords.addAll(rawWords);
      fullTargetTranscript += (fullTargetTranscript.isEmpty ? "" : " ") + targetRes.transcript;
      itemResults.add(targetRes);
    }

    String? fluencyFeedback;
    String? observations;

    if (allTargetWords.isNotEmpty && fullTargetTranscript.isNotEmpty) {
      final overallFeedback = await _computeOverallFeedback(allTargetWords, fullTargetTranscript);
      fluencyFeedback = overallFeedback.$1;
      observations = overallFeedback.$2;
    }

    return PronunciationFeedback(itemResults: itemResults, fluencyFeedback: fluencyFeedback, observations: observations);
  }
}
