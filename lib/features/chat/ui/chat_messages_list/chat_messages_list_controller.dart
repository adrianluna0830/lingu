
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:lingu/features/chat/chat_view.dart';
import 'package:signals/signals.dart';

class ChatMessagesListController
{
  final _messages = listSignal<ChatMessage>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;


  Function(ChatMessage)? onMessageTap;

  void setMessages(List<ChatMessage> messages) => _messages.value = messages;

  

}
