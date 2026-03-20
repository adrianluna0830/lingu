import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/core/ai/core/ai_chat_history.dart';
import 'package:lingu/core/ai/core/ai_chat_message.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';

enum GeminiModelType {
  gemini25FlashLite('gemini-2.5-flash-lite'),
  gemini25Flash('gemini-2.5-flash'),
  gemini25Pro('gemini-2.5-pro'),
  gemini20Flash('gemini-2.0-flash'),
  gemini20FlashLite('gemini-2.0-flash-lite');

  const GeminiModelType(this.value);
  final String value;
}

class GeminiModel extends IAIModel {
  final GoogleAIClient _client;
  final GeminiModelType modelType;

  GeminiModel({required GoogleAIClient client, required this.modelType}) : _client = client;

  @override
  Future<String> generateContent({
    required String prompt,
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
  }) async {
    final response = await _client.models.generateContent(
      model: modelType.value,
      request: GenerateContentRequest(
        contents: [Content.text(prompt)],
        systemInstruction: systemInstructions != null
            ? Content.text(systemInstructions)
            : null,
        generationConfig: _buildGenerationConfig(responseSchema),
      ),
    );
    return response.text ?? '';
  }

  @override
  Future<AIChatHistory> generateChatContent({
    required String prompt,
    AIChatHistory chatHistory = const AIChatHistory(),
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
  }) async {
    final historyWithUser = chatHistory.addUser(prompt);
    final response = await _client.models.generateContent(
      model: modelType.value,
      request: GenerateContentRequest(
        contents: _toContents(historyWithUser),
        systemInstruction: systemInstructions != null
            ? Content.text(systemInstructions)
            : null,
        generationConfig: _buildGenerationConfig(responseSchema),
      ),
    );
    final text = response.text ?? '';
    return historyWithUser.addModel(text);
  }

  void dispose() => _client.close();

  List<Content> _toContents(AIChatHistory history) {
    return history.messages.map((message) {
      return switch (message) {
        UserMessage(:final text) => Content(
            role: 'user',
            parts: [Part.text(text)],
          ),
        ModelMessage(:final text) => Content(
            role: 'model',
            parts: [Part.text(text)],
          ),
      };
    }).toList();
  }

  GenerationConfig? _buildGenerationConfig(Map<String, dynamic>? responseSchema) {
    if (responseSchema == null) return null;
    return GenerationConfig(
      responseMimeType: 'application/json',
      responseSchema: responseSchema,
    );
  }
}