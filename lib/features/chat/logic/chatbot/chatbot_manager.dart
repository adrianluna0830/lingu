import 'dart:async';
import 'package:lingu/core/ai/core/ai_chat_history.dart';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';

class ChatbotManager {
  final IAIService _aiService;
  final ChatMessagesManager _chatMessagesManager;

  AIChatHistory _chatHistory = AIChatHistory();

  ChatbotManager(this._aiService, this._chatMessagesManager);

  Future<AITextMessage> generateResponse(String userPrompt) async {
    _chatHistory = _chatHistory.addUser(userPrompt);
    
    final String systemPrompt = "You are a helpful language learning assistant. Help the user practice their language skills by providing feedback on their messages and responding in a conversational manner.";
    
    final response = await _aiService.generateChatContent(
      prompt: userPrompt,
      systemInstructions: systemPrompt,
      chatHistory: _chatHistory,
    );
    
    final aiText = response.messages.last.text;
    _chatHistory = _chatHistory.addModel(aiText);
    
    return await _chatMessagesManager.addAITextMessage(text: aiText);
  }
}
