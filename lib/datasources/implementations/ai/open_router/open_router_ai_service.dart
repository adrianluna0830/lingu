import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingu/domain/interfaces/ai/ai_chat_history.dart';
import 'package:lingu/domain/interfaces/ai/ai_chat_message.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';

class OpenRouterAiService extends IAIService {
  final String apiKey;
  final String model;

  static const _url = 'https://openrouter.ai/api/v1/chat/completions';

  OpenRouterAiService({
    required this.apiKey,
    this.model = 'qwen/qwen3.5-flash-02-23',
  });

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://lingu.app',
        'X-Title': 'Lingu',
      };

  List<Map<String, dynamic>> _buildMessages(
    String prompt, {
    AIChatHistory chatHistory = const AIChatHistory(),
    String? systemInstructions,
  }) {
    return [
      if (systemInstructions != null && systemInstructions.isNotEmpty)
        {'role': 'system', 'content': systemInstructions},
      for (final msg in chatHistory.messages)
        {'role': msg is UserMessage ? 'user' : 'assistant', 'content': msg.text},
      {'role': 'user', 'content': prompt},
    ];
  }

  Map<String, dynamic>? _buildResponseFormat(Map<String, dynamic>? schema) {
    if (schema == null) return null;
    return {
      'type': 'json_schema',
      'json_schema': {
        'name': 'response',
        'strict': true,
        'schema': _normalise(schema),
      },
    };
  }

  dynamic _normalise(dynamic node) {
    if (node is Map<String, dynamic>) {
      return {
        for (final e in node.entries)
          if (e.key != 'nullable')
            e.key: e.key == 'type' && e.value is String
                ? (e.value as String).toLowerCase()
                : _normalise(e.value),
      };
    }
    if (node is List) return node.map(_normalise).toList();
    return node;
  }

  Future<String> _post(List<Map<String, dynamic>> messages, Map<String, dynamic>? responseFormat) async {
    final body = <String, dynamic>{
      'model': model,
      'messages': messages,
      'reasoning': {'enabled': false},
      if (responseFormat != null) 'response_format': responseFormat,
    };

    final response = await http.post(
      Uri.parse(_url),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenRouter error ${response.statusCode}: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['choices'][0]['message']['content'] as String;
  }

  @override
  Future<String> generateContent({
    required String prompt,
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
    bool enableThinking = false,
  }) async {
    final messages = _buildMessages(prompt, systemInstructions: systemInstructions);
    return _post(messages, _buildResponseFormat(responseSchema));
  }

  @override
  Future<AIChatHistory> generateChatContent({
    required String prompt,
    AIChatHistory chatHistory = const AIChatHistory(),
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
    bool enableThinking = false,
  }) async {
    final messages = _buildMessages(prompt, chatHistory: chatHistory, systemInstructions: systemInstructions);
    final content = await _post(messages, _buildResponseFormat(responseSchema));
    return chatHistory.addUser(prompt).addModel(content);
  }

  Future<Map<String, dynamic>?> _fetchKeyData() async {
    final response = await http.get(
      Uri.parse('https://openrouter.ai/api/v1/auth/key'),
      headers: _headers,
    );
    if (response.statusCode != 200) return null;
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['data'] as Map<String, dynamic>?;
  }


  @override
  Future<double?> getCreditsUsage() async {
    final data = await _fetchKeyData();
    return (data?['usage'] as num?)?.toDouble();
  }
 
  @override
  Future<double?> getRemainingCreditsUsage() async {
    final data = await _fetchKeyData();
    final limit = (data?['limit'] as num?)?.toDouble();
    final usage = (data?['usage'] as num?)?.toDouble();
    if (limit == null || usage == null) return null;
    return limit - usage;
  }

}