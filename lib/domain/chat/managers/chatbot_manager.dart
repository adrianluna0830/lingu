import 'dart:async';
import 'dart:convert';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/domain/interfaces/ai/ai_chat_history.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:lingu/domain/chat/models/chat/chat_cefr.dart';
import 'package:lingu/domain/chat/models/chat/chat_languages.dart';
import 'package:lingu/domain/scripts/speech_timepoints_manager.dart';

sealed class ChatbotResponse {
  final AIChatHistory history;
  final String text;

  ChatbotResponse({required this.history, required this.text});
}

class TextChatbotResponse extends ChatbotResponse {
  TextChatbotResponse({required super.history, required super.text});
}

class AudioChatbotResponse extends ChatbotResponse {
  final SynthesisWithTimepoints audioResponse;

  AudioChatbotResponse({
    required super.history,
    required super.text,
    required this.audioResponse,
  });
}

class ChatbotAIResponse {
  final String text;

  ChatbotAIResponse({required this.text});

  static Schema get schema => Schema(
    type: SchemaType.object,
    properties: {
      'text': Schema(
        type: SchemaType.string,
        description: 'The AI response in the target language.',
      ),
    },
    required: ['text'],
  );

  factory ChatbotAIResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotAIResponse(text: json['text'] as String);
  }
}

class ChatbotManager {
  final IAIService _aiService;
  final SpeechTimepointsManager _synthesizeScript;
  final ChatLanguages _chatLanguages;
  final ChatCEFR _chatCefr;

  ChatbotManager(
    this._aiService,
    ITextToSpeechService ttsService,
    ISpeechToTextService sttService,
    this._chatLanguages,
    this._chatCefr,
  ) : _synthesizeScript = SpeechTimepointsManager(
          ttsService: ttsService,
          sttService: sttService,
        );

  Future<ChatbotResponse> generateNextResponse(
    AIChatHistory history,
    String userPrompt,
  ) async {
    return _generateAudioResponse(history, userPrompt);
  }

  Future<TextChatbotResponse> _generateTextResponse(
    AIChatHistory history,
    String userPrompt,
  ) async {
    final cefrLevel = _chatCefr.name;
    final systemPrompt = _getSystemPrompt(cefrLevel);

    final responseHistory = await _aiService.generateChatContent(
      prompt: userPrompt,
      systemInstructions: systemPrompt,
      chatHistory: history,
      responseSchema: ChatbotAIResponse.schema.toJson(),
    );

  final aiRawJson = responseHistory.messages.last.text;
    final json = jsonDecode(aiRawJson) as Map<String, dynamic>;
    final chatbotResponse = ChatbotAIResponse.fromJson(json);

    return TextChatbotResponse(
      history: responseHistory,
      text: chatbotResponse.text,
    );
  }

  Future<AudioChatbotResponse> _generateAudioResponse(
    AIChatHistory history,
    String userPrompt,
  ) async {
    final cefrLevel = _chatCefr.name;
    final systemPrompt = _getSystemPrompt(cefrLevel);

    final responseHistory = await _aiService.generateChatContent(
      prompt: userPrompt,
      systemInstructions: systemPrompt,
      chatHistory: history,
      responseSchema: ChatbotAIResponse.schema.toJson(),
    );
    print('Generated chatbot response history with ${responseHistory.messages.length} messages.');
    final aiRawJson = responseHistory.messages.last.text;
    final json = jsonDecode(aiRawJson) as Map<String, dynamic>;
    final chatbotResponse = ChatbotAIResponse.fromJson(json);
    print('Generated chatbot response: ${chatbotResponse.text}');
    final audioTimepoints = await _synthesizeScript.execute(
      text: chatbotResponse.text,
      languageLocale: _chatLanguages.target
    );
    print('Generated audio with duration ${audioTimepoints.duration} and ${audioTimepoints.timepoints.length} timepoints.');
    return AudioChatbotResponse(
      history: responseHistory,
      text: chatbotResponse.text,
      audioResponse: audioTimepoints,
    );
  }

  String _getSystemPrompt(String cefrLevel) {
    return "You are a friendly person having a natural, casual conversation with the user in ${_chatLanguages.target.name}. "
        "Keep your responses engaging and informal, as if talking to a friend. "
        "IMPORTANT: Adjust your language complexity (vocabulary and grammar) to match a $cefrLevel level student. "
        "Do not act as a teacher or provide feedback; just maintain a normal human-to-human conversation flow. "
        "Respond ONLY in ${_chatLanguages.target.name}.";
  }
}
