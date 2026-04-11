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


  Future<void> addUserTextMessage({required String text, required List<UserTextInput> individualTextInputs}) async {
    final id = _generateId();
    final message = UserTextMessage(
      id: id,
      text: text, individualTextInputs: individualTextInputs, 
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
  }

  Future<void> addUserAudioMessage({
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
  }

  void dispose() {
    _newMessageController.close();
  }
}
