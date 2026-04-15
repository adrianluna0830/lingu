import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/message/models/chat_panel_message.dart';
import 'package:lingu/features/chat/ui/chat_view.dart';

class ChatPanelMessages extends StatelessWidget {
  final List<ChatPanelMessage> messages;

  const ChatPanelMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.65,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 1.5),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.blue[100] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Text(msg.text),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
