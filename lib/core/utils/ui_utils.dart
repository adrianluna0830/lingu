import 'package:flutter/material.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';

String getLanguageDisplayName(LanguageLocale locale, BuildContext context) {
  return switch (locale) {
    LanguageLocale.en => 'English',
    LanguageLocale.es => 'Spanish',
    LanguageLocale.de => 'German',
  };
}

Color getLanguageColor(LanguageLocale locale) {
  return switch (locale) {
    LanguageLocale.en => Colors.blue.shade400,
    LanguageLocale.es => Colors.orange.shade400,
    LanguageLocale.de => Colors.red.shade400,
  };
}

Color getShadowColor(FeedbackResultEnum? severity) {
  if (severity == null || severity == FeedbackResultEnum.processing) return Colors.grey[700]!;
  return switch (severity) {
    FeedbackResultEnum.minor => Colors.orange,
    FeedbackResultEnum.major => Colors.red,
    FeedbackResultEnum.none => Colors.green,
    FeedbackResultEnum.processing => Colors.grey[700]!,
  };
}

Color? getErrorSeverityColor(ErrorSeverityEnum? severity) {
  if (severity == null) return null;
  return switch (severity) {
    ErrorSeverityEnum.bad => Colors.red,
    ErrorSeverityEnum.neutral => Colors.orange,
  };
}

