import 'dart:convert';
import 'package:lingu/domain/interfaces/ai/i_ai_schema_service.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/chat/models/chat/chat_languages.dart';
import 'package:lingu/domain/chat/models/chat/translated_text.dart';
import 'package:lingu/domain/chat/models/feedback/sentence_feedback.dart';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';

class StatementFeedbackResponse {
  final SentenceFeedback? fluency;
  final SentenceFeedback? grammar;
  final TranslatedText? translatedText;

  StatementFeedbackResponse({
    this.fluency,
    this.grammar,
    this.translatedText,
  });
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

    final schemaService = di<IAiSchemaService>();
    final schema = schemaService.getStatementFeedbackResponseSchema(hasNativeLanguage: hasNativeLanguage);

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
      responseSchema: schema,
    );

    final json = jsonDecode(response) as Map<String, dynamic>;
    return schemaService.parseStatementFeedbackResponse(json);
  }
}
