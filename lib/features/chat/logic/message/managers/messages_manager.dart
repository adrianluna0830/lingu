import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/models/message.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class MessagesManager {
  final Map<int, Message> _messagesById = {};
  final List<Message> _messagesList = [];
  final _messagesSignal = signal<List<Message>>([]);

  final StreamController<Message> _newUserMessageController =
      StreamController.broadcast();

  Stream<Message> get onNewUserMessageAdded =>
      _newUserMessageController.stream;

  ReadonlySignal<List<Message>> get messages => _messagesSignal;

  int _nextId = 0;

  void _appendMessage(Message message) {
    _messagesById[message.id] = message;
    _messagesList.add(message);
    _messagesSignal.value = List.unmodifiable(_messagesList);
  }

  int _generateId() => _nextId++;

  Future<void> addTextMessage({
    required String text,
    required bool isUser,
  }) async {
    final message = Message(
      id: _generateId(),
      isUserMessage: isUser,
      content: TextMessage(text),
    );
    _appendMessage(message);
    if (isUser) _newUserMessageController.add(message);
  }

  Future<void> addAudioMessage({
    required String audioUrl,
    required Duration duration,
    required bool isUser,
  }) async {
    final message = Message(
      id: _generateId(),
      isUserMessage: isUser,
      content: AudioMessage(audioUrl, duration),
    );
    _appendMessage(message);
    if (isUser) _newUserMessageController.add(message);
  }
}