import 'dart:convert';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/translated_text.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';

class StatementFeedbackResponse {
  final SentenceFeedback? fluency;
  final SentenceFeedback? grammar;
  final TranslatedText? translatedText;

  StatementFeedbackResponse({
    this.fluency,
    this.grammar,
    this.translatedText,
  });

  static Schema schema({required bool hasNativeLanguage}) => Schema(
        type: SchemaType.object,
        properties: {
          'fluency': SentenceFeedback.schema,
          'grammar': SentenceFeedback.schema,
          if (hasNativeLanguage) 'translatedText': TranslatedText.schema,
        },
      );

  factory StatementFeedbackResponse.fromJson(Map<String, dynamic> json) {
    return StatementFeedbackResponse(
      fluency: json['fluency'] != null
          ? SentenceFeedback.fromJson(json['fluency'] as Map<String, dynamic>)
          : null,
      grammar: json['grammar'] != null
          ? SentenceFeedback.fromJson(json['grammar'] as Map<String, dynamic>)
          : null,
      translatedText: json['translatedText'] != null
          ? TranslatedText.fromJson(
              json['translatedText'] as Map<String, dynamic>)
          : null,
    );
  }
}

class StatementFeedbackService {
  final IAIService _aiModel;
  final ChatLanguages _languages;

  StatementFeedbackService(this._aiModel, this._languages);

  Future<StatementFeedbackResponse> analyze({
    required String statement,
    required List<UserLanguageSegment> segments,
  }) async {
    final hasNativeLanguage = segments.any((s) => !s.isTargetLanguage);

    final schema =
        StatementFeedbackResponse.schema(hasNativeLanguage: hasNativeLanguage);

    final promptBuffer = StringBuffer();
    promptBuffer.write(
        "Analyze the following text, focusing on the parts written in ${_languages.target.bcp47}.\n\n");

    if (hasNativeLanguage) {
      promptBuffer.write(
          "- Since the input contains a mix of both ${_languages.target.bcp47} and ${_languages.native.bcp47}, provide a version fully in ${_languages.target.bcp47} (targetText) and its translation into ${_languages.native.bcp47} (translation) in the 'translatedText' field. Otherwise, set 'translatedText' to null.\n");
    }

    promptBuffer.write(
        "- Regardless of whether it's mixed or not, analyze the ${_languages.target.bcp47} portion for fluency and grammar issues. Provide corrections, explanations, and severity in ${_languages.native.bcp47}. "
        "Severity must be 'bad' for significant errors or 'neutral' for minor/stylistic improvements. "
        "If the target language part is perfect or no feedback is needed for a category, return null for that category.\n\n"
        "Text: \"$statement\"");

    final response = await _aiModel.generateContent(
      prompt: promptBuffer.toString(),
      responseSchema: schema.toJson(),
    );

    final json = jsonDecode(response) as Map<String, dynamic>;
    return StatementFeedbackResponse.fromJson(json);
  }
}
