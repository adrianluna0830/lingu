import 'dart:async';

import 'package:lingu/core/ai/core/ai_chat_history.dart';

abstract class IAiService {
  Future<String> generateContent({
    required String prompt,
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
  });

  Future<AIChatHistory> generateChatContent({
    required String prompt,
    AIChatHistory chatHistory = const AIChatHistory(),
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
  });
}