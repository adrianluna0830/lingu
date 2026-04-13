import 'package:flutter/material.dart';
import 'package:lingu/core/models/language_locale.dart';
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
  if (severity == null) return Colors.grey[400]!;
  return switch (severity) {
    FeedbackResultEnum.minor => Colors.orange,
    FeedbackResultEnum.major => Colors.red,
    FeedbackResultEnum.none => Colors.green,
  };
}

