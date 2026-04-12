import 'dart:convert';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';

class StatementFeedbackService {
  final IAiService _aiModel;
  final ChatLanguages _languages;

  StatementFeedbackService(this._aiModel, this._languages);

  Future<(SentenceFeedback? fluency, SentenceFeedback? grammar)> analyze(
      String statement) async {
    final schema = Schema(
      type: SchemaType.object,
      properties: {
        'fluency': Schema(
          type: SchemaType.object,
          properties: {
            'correction': Schema(type: SchemaType.string),
            'explanation': Schema(type: SchemaType.string),
          },
          nullable: true,
        ),
        'grammar': Schema(
          type: SchemaType.object,
          properties: {
            'correction': Schema(type: SchemaType.string),
            'explanation': Schema(type: SchemaType.string),
          },
          nullable: true,
        ),
      },
    );

    final prompt =
        "Analyze the following text in ${_getLanguageName(_languages.target)} and provide feedback in ${_getLanguageName(_languages.native)}. "
        "If there are issues with fluency or grammar, provide a correction and explanation. "
        "If the text is perfect or no feedback is needed for a category, return null for that category. "
        "Text: \"$statement\"";

    final response = await _aiModel.generateContent(
      prompt: prompt,
      responseSchema: schema.toJson(),
    );

    final jsonString = _cleanJson(response);
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final fluencyJson = json['fluency'] as Map<String, dynamic>?;
    final grammarJson = json['grammar'] as Map<String, dynamic>?;

    return (
      fluencyJson != null ? _parseFeedback(fluencyJson) : null,
      grammarJson != null ? _parseFeedback(grammarJson) : null,
    );
  }

  SentenceFeedback _parseFeedback(Map<String, dynamic> json) {
    return SentenceFeedback(
      correction: json['correction'],
      explanation: json['explanation'],
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
