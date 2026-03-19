import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/logic/message/message.dart';
import 'package:lingu/features/chat/ui/message_bubble.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note_controller.dart';
import 'package:signals/signals_flutter.dart';

class ChatMessagesList extends StatefulWidget {
  final ChatMessagesListController controller;
  const ChatMessagesList({super.key, required this.controller});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.controller.messages.watch(context).length,
      itemBuilder: (context, index) {
        final message = widget.controller.messages.watch(context)[index];

        Widget content = switch (message) {
          TextMessage textMessage => Text(textMessage.text),
          AudioMessage audioMessage => VoiceNote(audioMessage: audioMessage),
        };

        return Align(
          alignment: message.isUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: MessageBubble(content: content),
          ),
        );
      },
    );
  }
}
