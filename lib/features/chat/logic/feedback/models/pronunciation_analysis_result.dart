import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';

class BadSyllableFeedback {
  final String feedbackMessage;
  final ErrorSeverityEnum severity;

  BadSyllableFeedback({
    required this.feedbackMessage,
    required this.severity,
  });

  @override
  String toString() =>
      'BadSyllableFeedback(feedbackMessage: $feedbackMessage, severity: $severity)';
}

class SyllablePronunciationFeedback {
  final String syllable;
  final String userPronunciationFilePath;
  final String correctPronunciationFilePath;
  final BadSyllableFeedback? detail;

  SyllablePronunciationFeedback({
    required this.syllable,
    required this.userPronunciationFilePath,
    required this.correctPronunciationFilePath,
    this.detail,
  });

  @override
  String toString() =>
      'SyllablePronunciationFeedback(syllable: $syllable, userPronunciationFilePath: [audio], correctPronunciationFilePath: [audio], detail: $detail)';
}

class WordPronuniationFeedback {
  final String word;
  final String userPronunciationFilePath;
  final String correctPronunciationFilePath;
  final List<SyllablePronunciationFeedback> syllableFeedback;
  final bool isBad;

  WordPronuniationFeedback({
    required this.word,
    required this.userPronunciationFilePath,
    required this.correctPronunciationFilePath,
    required this.syllableFeedback,
    required this.isBad,
  });

  @override
  String toString() =>
      'WordPronuniationFeedback(word: $word, userPronunciationFilePath: [audio], correctPronunciationFilePath: [audio], isBad: $isBad, syllableFeedback: $syllableFeedback)';
}

sealed class PronunciationItemResult {
  final String transcript;
  final bool isTargetLanguage;

  PronunciationItemResult({
    required this.transcript,
    required this.isTargetLanguage,
  });
}

class NativeLanguagePronunciationResult extends PronunciationItemResult {
  NativeLanguagePronunciationResult({required super.transcript})
    : super(isTargetLanguage: false);

  @override
  String toString() => 'NativeLanguagePronunciationResult(transcript: $transcript)';
}

class TargetLanguatePronunciationResult extends PronunciationItemResult {
  final List<WordPronuniationFeedback> wordFeedback;
  TargetLanguatePronunciationResult({
    required super.transcript,
    required this.wordFeedback,
  }) : super(isTargetLanguage: true);

  @override
  String toString() =>
      'TargetLanguatePronunciationResult(transcript: $transcript, wordFeedback: $wordFeedback)';
}

class PronunciationAnalysisResult {
  final List<PronunciationItemResult> itemResults;

  PronunciationAnalysisResult({
    required this.itemResults,
  });

  String get rawTranscript => itemResults.map((e) => e.transcript).join(' ');

  @override
  String toString() => 'PronunciationAnalysisResult(itemResults: $itemResults)';
}
