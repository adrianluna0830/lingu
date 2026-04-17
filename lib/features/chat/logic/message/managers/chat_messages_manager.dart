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



  Future<AITextMessage> addAITextMessage({required String text}) async {
    final id = _generateId();
    final message = AITextMessage(id: id, text: text);
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }

  Future<AIAudioMessage> addAIAudioMessage({
    required String audioUrl, 
    required Duration duration, 
    required String transcription,
  }) async {
    final id = _generateId();
    final message = AIAudioMessage(
      id: id,
      duration: duration, 
      transcription: transcription, audioUrl: audioUrl,
    );
    _messages.value = [..._messages.value, message];
    _newMessageController.add(message);
    return message;
  }


  Future<UserTextMessage> addUserTextMessage({required String text, required List<UserTextInput> individualTextInputs}) async {
    final id = _generateId();
    final message = UserTextMessage(
      id: id,
      text: text, individualTextInputs: individualTextInputs, 
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
