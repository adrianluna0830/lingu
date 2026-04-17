import 'dart:async';
import 'package:lingu/features/chat/logic/chatbot/chatbot_manager.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/logic/chat_message_view_manager.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:signals/signals.dart';

class ChatOrchestrator {
  final ChatMessagesManager _chatMessagesManager;
  final MessageDetailsManager _messageDetailsManager;
  final ChatbotManager _chatbotManager;
  final ChatMessageViewManager _viewManager;

  ReadonlySignal<List<MessageViewDto>> get messages => _viewManager.messages;

  ChatOrchestrator(
    this._chatMessagesManager,
    this._messageDetailsManager,
    this._chatbotManager,
    this._viewManager,
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
    
    final aiMessage = await _chatbotManager.generateResponse(text);
    _viewManager.addMessage(aiMessage);
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

    final transcription = details.translatedText?.targetText ?? details.transcription;
    final aiMessage = await _chatbotManager.generateResponse(transcription);
    _viewManager.addMessage(aiMessage);
  }

  Future<void> handleFetchTranslation(int messageId, String content) async {
    final details = await _messageDetailsManager.fetchTranslation(messageId, content);
    if (details != null) {
      final message = _chatMessagesManager.messages.value.firstWhere((m) => m.id == messageId);
      _viewManager.updateMessage(message, details);
    }
  }
}
