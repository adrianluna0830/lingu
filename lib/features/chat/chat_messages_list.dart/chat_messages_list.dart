import 'package:flutter/material.dart';
import 'package:lingu/features/chat/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/message/message.dart';
import 'package:lingu/features/chat/ui/message_bubble.dart';
import 'package:signals/signals_flutter.dart';

class ChatMessagesList extends StatelessWidget {
  final ChatMessagesListController controller;
  const ChatMessagesList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.messages.watch(context).length,
      itemBuilder: (context, index) {
        final message = controller.messages.watch(context)[index];

        Widget content = switch (message) {
          TextMessage textMessage => Text(textMessage.text),
          AudioMessage audioMessage => Icon(Icons.audiotrack), // Placeholder for audio content
        };

        return Align(
          alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: MessageBubble(
            content: content,
            onTap: () => controller.onMessageTap?.call(message),
          ),
        );
      },
    );
  }
}