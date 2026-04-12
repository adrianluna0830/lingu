import 'package:flutter/material.dart';
import 'package:lingu/core/models/language_locale.dart';

String getLanguageDisplayName(LanguageLocale locale, BuildContext context) {
  // Hardcoded por ahora, preparado para localization después
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
