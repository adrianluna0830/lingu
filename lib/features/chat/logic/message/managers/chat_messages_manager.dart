import 'dart:async';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:signals/signals.dart';

class ChatMessagesManager {
  ChatMessagesManager();

  final _messages = signal<List<ChatMessage>>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;

  final _newMessageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get onNewMessage => _newMessageController.stream;

  int _nextId = 0;
  int _generateId() => _nextId++;

  Future<AITextMessage> addAITextMessage({
    required String text,
    String? translation,
  }) async {
    final id = _generateId();
    final message = AITextMessage(id: id, text: text, translation: translation);
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  Future<AIAudioMessage> addAIAudioMessage({
    required String audioUrl,
    required Duration duration,
    required String transcript,
    String? translation,
  }) async {
    final id = _generateId();
    final message = AIAudioMessage(
      id: id,
      duration: duration,
      transcript: transcript,
      audioUrl: audioUrl,
      translation: translation,
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  void updateMessage(ChatMessage updatedMessage) {
    _messages.value = _messages.value
        .map((m) => m.id == updatedMessage.id ? updatedMessage : m)
        .toList();
  }

  Future<UserTextMessage> addUserTextMessage({
    required String text,
    required List<UserTextInput> individualTextInputs,
  }) async {
    final id = _generateId();
    final message = UserTextMessage(
      id: id,
      text: text,
      individualTextInputs: individualTextInputs,
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  Future<UserAudioMessage> addUserAudioMessage({
    required String audioUrl,
    required Duration duration,
    required List<UserSpeechAudio> individualAudioUrls,
  }) async {
    final id = _generateId();
    final message = UserAudioMessage(
      id: id,
      fullMergedAudioFilePath: audioUrl,
      duration: duration,
      individualAudioFilePaths: individualAudioUrls,
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  void dispose() {
    _newMessageController.close();
  }
}
