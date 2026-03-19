import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/chat_messages_list.dart/chat_messages_list.dart';
import 'package:lingu/features/chat/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/input_bar/input_bar.dart';
import 'package:lingu/features/chat/input_bar/input_bar_controller.dart';
import 'package:lingu/features/chat/message/message.dart';
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

  void addAudioMessage({required String audioUrl, required bool isUser})
  {
    _messages.add(AudioMessage(audioUrl: audioUrl, isUser: isUser, id: _messageIdCounter++));
  }
}
@RoutePage()
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final InputBarController _inputBarController = InputBarController();
  final ChatMessagesListController controller = ChatMessagesListController();
  final ChatMessagesManager _messagesManager = di<ChatMessagesManager>();
  @override
  void initState() {
    super.initState();
    _inputBarController.onTextSubmit = (text) {
      _messagesManager.addTextMessage(text: text, isUser: true);
    };

    effect(() {
      controller.setMessages(_messagesManager.messages.value.toList());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat View')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: ChatMessagesList(controller: controller)),
          InputBar(_inputBarController),
        ],
      ),
    );
  }
}
