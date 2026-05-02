import 'dart:async';

import 'package:lingu/domain/interfaces/ai/ai_chat_history.dart';

abstract class IAIService {
  Future<String> generateContent({
    required String prompt,
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
    bool enableThinking = false,
  });

  Future<AIChatHistory> generateChatContent({
    required String prompt,
    AIChatHistory chatHistory = const AIChatHistory(),
    String? systemInstructions,
    Map<String, dynamic>? responseSchema,
    bool enableThinking = false,
  });

  Future<double?> getCreditsUsage();
  Future<double?> getRemainingCreditsUsage();
}