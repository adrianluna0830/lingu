import 'dart:async';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:signals/signals.dart';

class ChatMessagesManager {
  ChatMessagesManager();

  final _messages = signal<List<ChatMessageModel>>([]);
  ReadonlySignal<List<ChatMessageModel>> get messages => _messages;

  final _newMessageController = StreamController<ChatMessageModel>.broadcast();
  Stream<ChatMessageModel> get onNewMessage => _newMessageController.stream;

  int _nextId = 0;
  int _generateId() => _nextId++;

  Future<AITextMessageModel> addAITextMessage({
    required String text,
    String? translation,
  }) async {
    final id = _generateId();
    final message = AITextMessageModel(id: id, text: text, translation: translation);
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  Future<AIAudioMessageModel> addAIAudioMessage({
    required String audioUrl,
    required Duration duration,
    required String transcript,
    required List<SynthesisTimepoint> timepoints,
  }) async {
    final id = _generateId();
    final message = AIAudioMessageModel(
      id: id,
      duration: duration,
      transcript: transcript,
      audioUrl: audioUrl,
      timepoints: timepoints,
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  void updateMessage(ChatMessageModel updatedMessage) {
    _messages.value = _messages.value
        .map((m) => m.id == updatedMessage.id ? updatedMessage : m)
        .toList();
  }

  Future<UserTextMessageModel> addUserTextMessage({
    required String text,
    required List<UserTextInput> individualTextInputs,
  }) async {
    final id = _generateId();
    final message = UserTextMessageModel(
      id: id,
      text: text,
      individualTextInputs: individualTextInputs,
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  Future<UserAudioMessageModel> addUserAudioMessage({
    required String audioUrl,
    required Duration duration,
    required List<UserSpeechAudio> individualAudioUrls,
  }) async {
    final id = _generateId();
    final message = UserAudioMessageModel(
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
