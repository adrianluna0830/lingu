import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/features/chat/logic/feedback/feedback_correction_level.dart';
import 'package:lingu/features/chat/logic/feedback/user_audio_feedback_process.dart';
import 'package:lingu/features/chat/logic/feedback/user_feedback_analyzer.dart';
import 'package:lingu/features/chat/logic/feedback/user_text_feedback_process.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class ChatMessagesManager {
  final Map<int, ChatMessage> _messagesById = {};
  final List<ChatMessage> _messagesList = [];

  final _messagesSignal = signal<List<ChatMessage>>([]);

  ReadonlySignal<List<ChatMessage>> get messages => _messagesSignal;

  int _nextId = 0;

  void _appendMessage(ChatMessage message) {
    _messagesById[message.id] = message;
    _messagesList.add(message);
    _messagesSignal.value = List.unmodifiable(_messagesList);
  }

  int _generateId() {
    return _nextId++;
  }

  Future<UserTextMessage> addUserTextMessage({required String text}) async {
    final message = UserTextMessage(id: _generateId(), text: text);

    _appendMessage(message);
    return message;
  }

  Future<UserAudioMessage> addUserAudioMessage({
    required String audioUrl,
    required Duration duration,
  }) async {
    final message = UserAudioMessage(
      id: _generateId(),
      audioUrl: audioUrl,
      duration: duration,
    );

    _appendMessage(message);
    return message;
  }

  Future<AITextMessage> addBotTextMessage({required String text}) async {
    final message = AITextMessage(id: _generateId(), text: text);

    _appendMessage(message);
    return message;
  }

  Future<AIAudioMessage> addBotAudioMessage({
    required String audioUrl,
    required Duration duration,
  }) async {
    final message = AIAudioMessage(
      id: _generateId(),
      audioUrl: audioUrl,
      duration: duration,
    );

    _appendMessage(message);
    return message;
  }

  void removeMessage(int id) {
    final msg = _messagesById.remove(id);
    if (msg == null) return;

    _messagesList.remove(msg);
    _messagesSignal.value = List.unmodifiable(_messagesList);
  }

  void updateMessage(ChatMessage updatedMessage) {
    final existing = _messagesById[updatedMessage.id];
    if (existing == null) return;

    final index = _messagesList.indexWhere((m) => m.id == updatedMessage.id);
    if (index == -1) return;

    _messagesList[index] = updatedMessage;
    _messagesById[updatedMessage.id] = updatedMessage;

    _messagesSignal.value = List.unmodifiable(_messagesList);
  }
}

@Singleton(scope: 'chat')
class AIMessagesManager {
  final ChatMessagesManager _chatMessagesManager;
  final UserMessagesHandler _userMessagesHandler;
  final ITextToSpeechService _textToSpeechService;
  final IAudioPlayerManager _audioPlayerManager;
  final IAIModel _aiModel;

  AIMessagesManager(
    this._chatMessagesManager,
    this._userMessagesHandler,
    this._textToSpeechService,
    this._audioPlayerManager,
    this._aiModel,
  ) {
    effect(_onMessagesChanged);
  }

  void _onMessagesChanged() {
    final messages = _chatMessagesManager.messages.value;
    if (messages.isEmpty) return;
    
    final lastMessage = messages.last;

    if (lastMessage is UserTextMessage) {
      _handleTextMessage(lastMessage);
    } else if (lastMessage is UserAudioMessage) {
      _handleAudioMessage(lastMessage);
    }
  }

  void _handleTextMessage(UserTextMessage message) {
    if (message.feedbackProcess is! TextFeedbackResult) return;
    final feedbackResult = message.feedbackProcess as TextFeedbackResult;
  }

  void _handleAudioMessage(UserAudioMessage message) {
    if (message.feedbackProcess is! AudioFeedbackResult) return;
    final feedbackResult = message.feedbackProcess as AudioFeedbackResult;
  }

  Future<void> sendMessage() async {}
}

@injectable
class UserMessagesHandler {
  final ChatMessagesManager _messagesManager;
  final UserFeedbackAnalyzer _feedbackAnalyzer;

  UserMessagesHandler(
    this._messagesManager,
    this._feedbackAnalyzer,
  );


  ReadonlySignal<List<ChatMessage>> get messages => _messagesManager.messages;

  Future<void> sendTextMessage({required String text}) async {
    final message = await _messagesManager.addUserTextMessage(text: text);
    final (UserFeedback? fluency, UserFeedback? grammar) = await _feedbackAnalyzer.analyze(text);
    final updatedMessage = message.copyWith(feedbackProcess: TextFeedbackResult(feedback: fluency, grammar: grammar),);
    _messagesManager.updateMessage(updatedMessage);
  }

}
