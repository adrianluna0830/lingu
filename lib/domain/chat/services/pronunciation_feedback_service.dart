import 'dart:convert';
import 'dart:typed_data';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/interfaces/audio_utils/i_audio_utils.dart';
import 'package:lingu/domain/pronunciation/models/pronunciation_assessment_result.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_schema_service.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/interfaces/pronunciation_assessment/i_pronunciation_assessment.dart';
import 'package:lingu/domain/interfaces/stt/audio_encoding_enum.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/chat/models/chat/chat_languages.dart';
import 'package:lingu/domain/chat/models/enums/error_severity_enum.dart';
import 'package:lingu/domain/chat/models/feedback/pronunciation_feedback.dart';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';

class AISyllableResponse {
  final String syllablePlainText;
  final String ipa;
  final (String feedback, ErrorSeverityEnum severity)? feedback;
  AISyllableResponse(this.syllablePlainText, this.ipa, this.feedback);

  factory AISyllableResponse.fromJson(Map<String, dynamic> json) {
    final feedbackMap = json['feedback'] as Map<String, dynamic>?;
    (String, ErrorSeverityEnum)? feedbackTuple;
    if (feedbackMap != null) {
      final feedbackMsg = feedbackMap['feedback'] as String;
      final severityStr = feedbackMap['severity'] as String;
      final severity = severityStr == 'bad' ? ErrorSeverityEnum.bad : ErrorSeverityEnum.neutral;
      feedbackTuple = (feedbackMsg, severity);
    }
    return AISyllableResponse(json['syllablePlainText'] as String, json['ipa'] as String, feedbackTuple);
  }
}

class AIPronunciationResponse {
  final String wordSSML;
  final List<AISyllableResponse> syllableFeedback;
  AIPronunciationResponse({required this.wordSSML, required this.syllableFeedback});
}

class AIOverallPronunciationResponse {
  final String? fluencyFeedback;

  AIOverallPronunciationResponse({this.fluencyFeedback});
}

class PronunciationFeedbackService {
  final int wordContextSize = 5;
  final int goodPronunciationThreshold = 80;

  final IPronunciationAssessmentService _assessmentService;
  final IAIService _aiModel;
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

For each syllable provide TWO separate fields:

1. `syllablePlainText` (Visual / Orthographic):
   This represents the EXACT, literal spelling of the word "$word" broken into parts. 
   ABSOLUTE RULE 1: It must contain ONLY standard alphabet letters (a-z). No phonetic symbols whatsoever.
   ABSOLUTE RULE 2: If you concatenate every `syllablePlainText` in your response mathematically, it MUST perfectly reconstruct the original word "$word" character by character. 
   ABSOLUTE RULE 3: Do NOT omit unpronounced, dropped, or silent letters. Even if the speech recognizer missed sounds, you MUST include the full strict spelling of the original word.
   
   Examples of handling unpronounced or dropped letters:
   - Word: "with" (Recognizer heard: "wi") -> Correct `syllablePlainText`: "with" (NEVER "wi")
   - Word: "and" (Recognizer heard: "an") -> Correct `syllablePlainText`: "and" (NEVER "an")
   - Word: "stuff" (Recognizer heard: "stf") -> Correct `syllablePlainText`: "stuff" (NEVER "st", "f")

2. `ipa` (Sound / Phonetic):
   The correct IPA phonetic transcription for that syllable only. This is the ONLY place where IPA and phonetic representation are allowed.

The `feedback`: An object containing the feedback message and severity. The feedback MUST be written in the user's native language (${_languages.native.name}). Make it helpful and concise. If the syllable was pronounced correctly (or the error is negligible), omit the `feedback` property entirely (make it null). The severity should be "bad" or "neutral".
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
1. `fluencyFeedback`: Provide tips on how to sound more native for this phrase. Focus ONLY on things that help with native-like fluency, such as word linking (how words flow together), rhythm, intonation, or specific diphthongs/combinations that change in natural speech. 
DO NOT give general pronunciation tips for individual words (as those are already covered). Only provide this if there's a specific "pro-tip" that would make the user sound significantly more like a native speaker. 
If the user's flow is already good or there are no specific native-like tips to give for this phrase, leave it null. (This should be null approximately 70% of the time).

The feedback MUST be written in the user's native language (${_languages.native.name}).
''';
  }

  Future<WordPronunciationFeedback> _computeWordFeedback(Uint8List audioBytes, PronunciationAssessmentWordResult wordResult) async {
    final userWordPronunciationBytes = await _audioUtils.cut(audioBytes, Duration(microseconds: wordResult.offset ~/ 10), Duration(microseconds: wordResult.duration ~/ 10));
    final userWordPronunciationFilePath = await _audioUtils.saveToPath(userWordPronunciationBytes, true);

    List<String> syllables = wordResult.syllables?.map((s) => s.syllable).toList() ?? [];
    List<String> spokenPhonemes = wordResult.phonemes?.map((p) => p.phoneme).toList() ?? [];

    final String prompt = _generatePronunciationPrompt(wordResult.word, syllables, spokenPhonemes, wordResult.pronunciationAssessment.accuracyScore);

    final schemaService = di<IAiSchemaService>();
    final schema = schemaService.getAIPronunciationResponseSchema(_languages.native.name);
    final aiResponseText = await _aiModel.generateContent(prompt: prompt, responseSchema: schema);

    final jsonResponse = jsonDecode(aiResponseText) as Map<String, dynamic>;
    final aiPronunciation = schemaService.parseAIPronunciationResponse(jsonResponse);

    final voiceName = '${_languages.target.bcp47}-Standard-A';
    final correctWordPronunciationResponse = await _ttsService.synthesizeSpeechText(
      text: aiPronunciation.wordSSML,
      languageCode: _languages.target.bcp47,
      voiceName: voiceName,
    );
    final correctPronunciationFilePath = await _audioUtils.saveToPath(correctWordPronunciationResponse.audioBytes, true);

    List<SyllablePronunciationFeedback> finalSyllableFeedbacks = [];
    if (wordResult.syllables != null) {
      for (int i = 0; i < wordResult.syllables!.length; i++) {
        var origSyllable = wordResult.syllables![i];
        BadSyllableFeedback? detail;
        String? syllableIpa;
        String syllableText = origSyllable.syllable;
        
        try {
          if (i < aiPronunciation.syllableFeedback.length) {
            final aiSyllable = aiPronunciation.syllableFeedback[i];
            syllableIpa = aiSyllable.ipa.replaceAll(RegExp(r'''^['"]+|['"]+$'''), '');
            syllableText = aiSyllable.syllablePlainText;
            if (aiSyllable.feedback != null) {
              detail = BadSyllableFeedback(feedbackMessage: aiSyllable.feedback!.$1, severity: aiSyllable.feedback!.$2);
            }
          }
        } catch (_) {}

        final userSyllableBytes = await _audioUtils.cut(audioBytes, Duration(microseconds: origSyllable.offset ~/ 10), Duration(microseconds: origSyllable.duration ~/ 10));
        final userSyllablePath = await _audioUtils.saveToPath(userSyllableBytes, true);

        final bool useIPA = syllableIpa != null && syllableIpa.isNotEmpty;
        final String ttsText = useIPA ? syllableIpa : origSyllable.syllable;
        
        final correctSyllableResponse = await _ttsService.synthesizeSpeechText(
          text: ttsText,
          languageCode: _languages.target.bcp47,
          voiceName: voiceName,
          isIPA: useIPA,
        );
        final correctSyllablePath = await _audioUtils.saveToPath(correctSyllableResponse.audioBytes, true);

        finalSyllableFeedbacks.add(
          SyllablePronunciationFeedback(
            syllable: syllableText,
            userPronunciationFilePath: userSyllablePath,
            correctPronunciationFilePath: correctSyllablePath,
            detail: detail,
          )
        );
      }
    }

    final bool isBad = wordResult.pronunciationAssessment.accuracyScore < goodPronunciationThreshold;

    BadWordFeedback? detail;
    if (isBad || finalSyllableFeedbacks.isNotEmpty) {
      detail = BadWordFeedback(
        userPronunciationFilePath: userWordPronunciationFilePath,
        correctPronunciationFilePath: correctPronunciationFilePath,
        syllableFeedback: finalSyllableFeedbacks,
      );
    }

    return WordPronunciationFeedback(
      word: wordResult.word,
      detail: detail,
    );
  }

  Future<(TargetLanguagePronunciationResult, List<PronunciationAssessmentWordResult>)> _computeTargetLanguageResult(Uint8List audioBytes) async {
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

  Future<String?> _computeOverallFeedback(List<PronunciationAssessmentWordResult> allWords, String fullTranscript) async {
    if (allWords.isEmpty) return null;

    final wordDetails = allWords
        .map((w) {
          final syllables = w.syllables?.map((s) => s.syllable).join('-') ?? '';
          final phonemes = w.phonemes?.map((p) => p.phoneme).join(' ') ?? '';
          return 'Word: "${w.word}", Syllables: [$syllables], Phonemes: [$phonemes], Accuracy: ${w.pronunciationAssessment.accuracyScore}';
        })
        .join('\n');

    final prompt = _generateOverallFeedbackPrompt(fullTranscript, wordDetails);

final schemaService = di<IAiSchemaService>();
    final schema = schemaService.getAIOverallPronunciationResponseSchema(_languages.native.name);
    final aiResponseText = await _aiModel.generateContent(prompt: prompt, responseSchema: schema);
    
    final jsonResponse = jsonDecode(aiResponseText) as Map<String, dynamic>;
    final aiResult = schemaService.parseAIOverallPronunciationResponse(jsonResponse);

    return aiResult.fluencyFeedback;
  }

  Future<PronunciationFeedback> analyze(List<UserSpeechAudio> audioFiles) async {
    List<PronunciationItemResult> itemResults = [];
    List<PronunciationAssessmentWordResult> allTargetWords = [];
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

    if (allTargetWords.isNotEmpty && fullTargetTranscript.isNotEmpty) {
      fluencyFeedback = await _computeOverallFeedback(allTargetWords, fullTargetTranscript);
    }

    return PronunciationFeedback(itemResults: itemResults, fluencyFeedback: fluencyFeedback);
  }
}
