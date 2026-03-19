import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/message.dart';
import 'package:signals/signals.dart';

@singleton
class ChatMessagesManager
{
  final _messages = listSignal<Message>([]);
  ReadonlySignal<List<Message>> get messages => _messages;
  

  int _messageIdCounter = 0;

  void addTextMessage({required String text, required bool isUser})
  {
    _messages.add(TextMessage(text: text, isUser: isUser, id: _messageIdCounter++));
  }

  void addAudioMessage({required String audioUrl, required bool isUser, required Duration duration})
  {
    _messages.add(AudioMessage(audioUrl: audioUrl, isUser: isUser, id: _messageIdCounter++, duration: duration));
  }
}