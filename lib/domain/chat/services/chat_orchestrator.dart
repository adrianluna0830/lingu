import 'dart:async';
import 'package:lingu/domain/interfaces/ai/ai_chat_history.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/interfaces/audio_utils/i_audio_utils.dart';
import 'package:lingu/domain/chat/models/chat/chat_languages.dart';
import 'package:lingu/domain/chat/managers/chatbot_manager.dart';
import 'package:lingu/domain/chat/managers/message_details_manager.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/domain/chat/managers/chat_messages_manager.dart';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';
import 'package:lingu/domain/chat/managers/chat_message_view_manager.dart';
import 'package:lingu/presentation/screens/chat/models/message_view_dto.dart';
import 'package:signals/signals.dart';

class ChatOrchestrator {
  final ChatMessagesManager _chatMessagesManager;
  final MessageDetailsManager _messageDetailsManager;
  final ChatbotManager _chatbotManager;
  final ChatMessageViewManager _viewManager;
  final IAIService _aiModel;
  final ChatLanguages _languages;
  final IAudioUtils _audioUtils;

  AIChatHistory _chatHistory = const AIChatHistory();

  ReadonlySignal<List<MessageViewDto>> get messages => _viewManager.messages;

  ChatOrchestrator(
    this._chatMessagesManager,
    this._messageDetailsManager,
    this._chatbotManager,
    this._viewManager,
    this._aiModel,
    this._languages,
    this._audioUtils,
  );

  Future<void> handleUserTextMessage({
    required String text,
    required List<UserTextInput> individualTextInputs,
  }) async {
    final message = await _chatMessagesManager.addUserTextMessage(
      text: text,
      individualTextInputs: individualTextInputs,
    );

    _viewManager.addMessage(message);

    final details = await _messageDetailsManager.fetchTextFeedback(
      message.id,
      individualTextInputs,
    );

    _viewManager.updateMessage(message, details);

    await _generateAndHandleAIResponse(text);
  }

  Future<void> handleUserAudioMessage({
    required String audioUrl,
    required Duration duration,
    required List<UserSpeechAudio> individualAudioUrls,
  }) async {
    final message = await _chatMessagesManager.addUserAudioMessage(
      audioUrl: audioUrl,
      duration: duration,
      individualAudioUrls: individualAudioUrls,
    );

    _viewManager.addMessage(message);

    final details = await _messageDetailsManager.fetchAudioFeedback(
      message.id,
      individualAudioUrls,
    );

    _viewManager.updateMessage(message, details);

    final transcription =
        details.translatedText?.targetText ?? details.transcription;
    await _generateAndHandleAIResponse(transcription);
  }

  Future<void> _generateAndHandleAIResponse(String prompt) async {
    final chatbotResponse = await _chatbotManager.generateNextResponse(
      _chatHistory,
      prompt,
    );
    _chatHistory = chatbotResponse.history;

    switch (chatbotResponse) {
      case TextChatbotResponse():
        final aiMessage = await _chatMessagesManager.addAITextMessage(
          text: chatbotResponse.text,
        );
        _viewManager.addMessage(aiMessage);
      case AudioChatbotResponse():
        final ttsResponse = chatbotResponse.audioResponse;
        final audioUrl = await _audioUtils.saveToPath(
          ttsResponse.audioBytes,
          true,
        );
        final duration = ttsResponse.duration;

        final aiMessage = await _chatMessagesManager.addAIAudioMessage(
          audioUrl: audioUrl,
          duration: duration,
          transcript: chatbotResponse.text,
        );
        _viewManager.addMessage(aiMessage);

        _messageDetailsManager.setAiAudioDetails(
          aiMessage.id,
          ttsResponse.timepoints,
          duration,
          audioUrl,
        );
    }
  }

  Future<void> handleFetchTranslation(int messageId, String content) async {
    final message = _chatMessagesManager.messages.value.firstWhere(
      (m) => m.id == messageId,
    );

    if (message is AITextMessageModel && message.translation != null) return;
    if (message is AIAudioMessageModel && message.translation != null) return;

    final String prompt =
        "Translate the following text to ${_languages.native.bcp47}, the output should be only a translation: $content ";
    final response = await _aiModel.generateContent(prompt: prompt);

    if (message is AITextMessageModel) {
      final updatedMessage = message.copyWith(translation: response);
      _chatMessagesManager.updateMessage(updatedMessage);
      final details = _messageDetailsManager.messageDetails.value[messageId];
      if (details != null) {
        _viewManager.updateMessage(updatedMessage, details);
      }
    } else if (message is AIAudioMessageModel) {
      final updatedMessage = message.copyWith(translation: response);
      _chatMessagesManager.updateMessage(updatedMessage);
      final details = _messageDetailsManager.messageDetails.value[messageId];
      if (details != null) {
        _viewManager.updateMessage(updatedMessage, details);
      }
    }
  }
}
