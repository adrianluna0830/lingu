import 'package:lingu/domain/chat/models/chat/translated_text.dart';
import 'package:lingu/domain/chat/models/feedback/sentence_feedback.dart';
import 'package:lingu/domain/chat/services/pronunciation_feedback_service.dart';
import 'package:lingu/domain/chat/services/statement_feedback_service.dart';
import 'package:lingu/domain/word/models/ai_word_response.dart';

abstract class IAiSchemaService {
  // Statement Feedback
  Map<String, dynamic> getSentenceFeedbackSchema();
  SentenceFeedback parseSentenceFeedback(Map<String, dynamic> json);

  Map<String, dynamic> getTranslatedTextSchema();
  TranslatedText parseTranslatedText(Map<String, dynamic> json);

  Map<String, dynamic> getStatementFeedbackResponseSchema({required bool hasNativeLanguage});
  StatementFeedbackResponse parseStatementFeedbackResponse(Map<String, dynamic> json);

  // Pronunciation Responses
  Map<String, dynamic> getAIPronunciationResponseSchema(String nativeLanguageName);
  AIPronunciationResponse parseAIPronunciationResponse(Map<String, dynamic> json);

  Map<String, dynamic> getAIOverallPronunciationResponseSchema(String nativeLanguageName);
  AIOverallPronunciationResponse parseAIOverallPronunciationResponse(Map<String, dynamic> json);

  // Word Responses
  Map<String, dynamic> getAIWordResponseSchema(Map<String, dynamic> languageSpecificDetails);
  AIWordResponse<T> parseAIWordResponse<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) detailsFromJson);

  Map<String, dynamic> getEnglishWordDetailsSchema();
  Map<String, dynamic> getGermanWordDetailsSchema();
  Map<String, dynamic> getSpanishWordDetailsSchema();
}