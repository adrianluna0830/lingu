import 'dart:math';

import 'package:lingu/core/pronunciation/models/pronunciation_assessment_dto.dart';
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

class PronunciationFeedback {
  final List<PronunciationItemResult> itemResults;
  final String? fluencyFeedback;
  final String? observations;

  PronunciationFeedback({
    required this.itemResults,
    this.fluencyFeedback,
    this.observations,
  });

  String get rawTranscript => itemResults.map((e) => e.transcript).join(' ');

  FeedbackResultEnum get mostSevere {
    var maxSeverity = FeedbackResultEnum.none;

    for (var item in itemResults) {
      if (item is TargetLanguagePronunciationResult) {
        for (var word in item.wordFeedback) {
          for (var syllable in word.syllableFeedback) {
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
