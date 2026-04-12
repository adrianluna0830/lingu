import 'dart:convert';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/translated_text.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';

class StatementFeedbackService {
  final IAiService _aiModel;
  final ChatLanguages _languages;

  StatementFeedbackService(this._aiModel, this._languages);

  Future<(SentenceFeedback? fluency, SentenceFeedback? grammar, TranslatedText? translatedText)> analyze(
      String statement) async {
    final schema = Schema(
      type: SchemaType.object,
      properties: {
        'fluency': Schema(
          type: SchemaType.object,
          properties: {
            'correction': Schema(type: SchemaType.string),
            'explanation': Schema(type: SchemaType.string),
            'severity': Schema(
              type: SchemaType.string,
              enumValues: ['bad', 'neutral'],
            ),
          },
          nullable: true,
        ),
        'grammar': Schema(
          type: SchemaType.object,
          properties: {
            'correction': Schema(type: SchemaType.string),
            'explanation': Schema(type: SchemaType.string),
            'severity': Schema(
              type: SchemaType.string,
              enumValues: ['bad', 'neutral'],
            ),
          },
          nullable: true,
        ),
        'translatedText': Schema(
          type: SchemaType.object,
          properties: {
            'targetText': Schema(type: SchemaType.string),
            'translation': Schema(type: SchemaType.string),
          },
          nullable: true,
        ),
      },
    );

    final prompt =
        "Analyze the following text, focusing on the parts written in ${_getLanguageName(_languages.target)}. "
        "1. If the input contains a mix of both ${_getLanguageName(_languages.target)} and ${_getLanguageName(_languages.native)}, provide a version fully in ${_getLanguageName(_languages.target)} (targetText) and its translation into ${_getLanguageName(_languages.native)} (translation) in the 'translatedText' field. Otherwise, set 'translatedText' to null.\n"
        "2. Regardless of whether it's mixed or not, analyze the ${_getLanguageName(_languages.target)} portion for fluency and grammar issues. Provide corrections, explanations, and severity in ${_getLanguageName(_languages.native)}. "
        "Severity must be 'bad' for significant errors or 'neutral' for minor/stylistic improvements. "
        "If the target language part is perfect or no feedback is needed for a category, return null for that category.\n"
        "Text: \"$statement\"";

    final response = await _aiModel.generateContent(
      prompt: prompt,
      responseSchema: schema.toJson(),
    );

    final jsonString = _cleanJson(response);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final fluencyJson = json['fluency'] as Map<String, dynamic>?;
    final grammarJson = json['grammar'] as Map<String, dynamic>?;
    final translatedJson = json['translatedText'] as Map<String, dynamic>?;

    return (
      fluencyJson != null ? _parseFeedback(fluencyJson) : null,
      grammarJson != null ? _parseFeedback(grammarJson) : null,
      translatedJson != null ? _parseTranslatedText(translatedJson) : null,
    );
  }

  SentenceFeedback _parseFeedback(Map<String, dynamic> json) {
    return SentenceFeedback(
      correction: json['correction'],
      explanation: json['explanation'],
      severity: ErrorSeverityEnum.values.byName(json['severity']),
    );
  }

  TranslatedText _parseTranslatedText(Map<String, dynamic> json) {
    return TranslatedText(
      targetText: json['targetText'],
      translation: json['translation'],
    );
  }

  String _cleanJson(String text) {
    text = text.trim();
    if (text.startsWith('```json')) {
      text = text.substring(7);
    } else if (text.startsWith('```')) {
      text = text.substring(3);
    }
    if (text.endsWith('```')) {
      text = text.substring(0, text.length - 3);
    }
    return text.trim();
  }

  String _getLanguageName(LanguageLocale locale) {
    switch (locale) {
      case LanguageLocale.en:
        return 'English';
      case LanguageLocale.es:
        return 'Spanish';
      case LanguageLocale.de:
        return 'German';
    }
  }
}
