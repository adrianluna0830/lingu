import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';

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

class BadWordFeedback {
  final String userPronunciationFilePath;
  final String correctPronunciationFilePath;
  final List<SyllablePronunciationFeedback> syllableFeedback;

  BadWordFeedback({
    required this.userPronunciationFilePath,
    required this.correctPronunciationFilePath,
    required this.syllableFeedback,
  });

  ErrorSeverityEnum? get mostSevere {
    ErrorSeverityEnum? maxSeverity;

    for (var syllable in syllableFeedback) {
      if (syllable.detail != null) {
        final currentSeverity = syllable.detail!.severity;
        if (maxSeverity == null || currentSeverity.index < maxSeverity.index) {
          maxSeverity = currentSeverity;
        }
      }
    }
    return maxSeverity;
  }

  @override
  String toString() =>
      'BadWordFeedback(userPronunciationFilePath: [audio], correctPronunciationFilePath: [audio], syllableFeedback: $syllableFeedback)';
}

class WordPronunciationFeedback {
  final String word;
  final BadWordFeedback? detail;

  WordPronunciationFeedback({
    required this.word,
    this.detail,
  });

  @override
  String toString() =>
      'WordPronunciationFeedback(word: $word, detail: $detail)';
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

class PronunciationFeedback {
  final List<PronunciationItemResult> itemResults;
  final String? fluencyFeedback;

  PronunciationFeedback({
    required this.itemResults,
    this.fluencyFeedback,
  });

  String get rawTranscript => itemResults.map((e) => e.transcript).join(' ');

  FeedbackResultEnum get mostSevere {
    var maxSeverity = FeedbackResultEnum.none;

    for (var item in itemResults) {
      if (item is TargetLanguagePronunciationResult) {
        for (var word in item.wordFeedback) {
          if (word.detail != null) {
            for (var syllable in word.detail!.syllableFeedback) {
              if (syllable.detail != null) {
                final currentSeverity = _mapErrorToFeedback(syllable.detail!.severity);
                if (currentSeverity.index > maxSeverity.index) {
                  maxSeverity = currentSeverity;
                }
              }
            }
          }
        }
      }
    }
    return maxSeverity;
  }

  FeedbackResultEnum _mapErrorToFeedback(ErrorSeverityEnum error) {
    return switch (error) {
      ErrorSeverityEnum.bad => FeedbackResultEnum.major,
      ErrorSeverityEnum.neutral => FeedbackResultEnum.minor,
    };
  }

  @override
  String toString() => 'PronunciationAnalysisResult(itemResults: $itemResults)';
}
