import 'package:lingu/features/chat/message/message.dart';
import 'package:signals/signals.dart';

class ChatMessagesListController
{
  final _messages = listSignal<Message>([]);
  
  ReadonlySignal<List<Message>> get messages => _messages;

  Function(Message)? onMessageTap;

  void setMessages(List<Message> messages)
  => _messages.value = messages;

}
