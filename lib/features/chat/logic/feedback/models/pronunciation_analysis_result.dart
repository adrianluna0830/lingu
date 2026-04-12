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

class WordPronunciationFeedback {
  final String word;
  final String userPronunciationFilePath;
  final String correctPronunciationFilePath;
  final List<SyllablePronunciationFeedback> syllableFeedback;
  final bool isBad;

  WordPronunciationFeedback({
    required this.word,
    required this.userPronunciationFilePath,
    required this.correctPronunciationFilePath,
    required this.syllableFeedback,
    required this.isBad,
  });

  @override
  String toString() =>
      'WordPronunciationFeedback(word: $word, userPronunciationFilePath: [audio], correctPronunciationFilePath: [audio], isBad: $isBad, syllableFeedback: $syllableFeedback)';
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

class TargetLanguagePronunciationResult extends PronunciationItemResult {
  final List<WordPronunciationFeedback> wordFeedback;
  TargetLanguagePronunciationResult({
    required super.transcript,
    required this.wordFeedback,
  }) : super(isTargetLanguage: true);

  @override
  String toString() =>
      'TargetLanguagePronunciationResult(transcript: $transcript, wordFeedback: $wordFeedback)';
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
