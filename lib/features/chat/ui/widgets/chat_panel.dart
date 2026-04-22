import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_controller.dart';
import 'package:lingu/features/chat/logic/message/models/chat_panel_message.dart';
import 'package:lingu/features/chat/ui/widgets/chat_panel_messages.dart';
import 'package:lingu/features/chat/ui/widgets/new_chat_prompt_popup.dart';

class ChatPanel extends StatefulWidget {
  final List<ChatPanelMessage> messages;
  final ChatPanelController? controller;
  final String? initialMessage;

  const ChatPanel({super.key, required this.messages, this.controller, this.initialMessage});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final TextEditingController _inputController = TextEditingController();
  final StreamController<String?> _popupStreamController = StreamController<String?>.broadcast();

  @override
  void initState() {
    super.initState();

    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _popupStreamController.add(widget.initialMessage);
      });
    }
  }

  @override
  void didUpdateWidget(ChatPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialMessage != null && widget.initialMessage != oldWidget.initialMessage) {
      _popupStreamController.add(widget.initialMessage);
    }
  }

  @override
  void dispose() {
    _popupStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Column(
          children: [
            Expanded(child: ChatPanelMessages(messages: widget.messages)),
            ChatInput(
              controller: _inputController,
              onSend: (text) => widget.controller?.onNewUserMessage?.call(text),
              onNewChat: () => _popupStreamController.add(''),
            ),
          ],
        ),
        StreamBuilder<String?>(
          stream: _popupStreamController.stream,
          builder: (context, snapshot) {
            final question = snapshot.data;
            if (question == null) {
              return const SizedBox.shrink();
            }

            return NewChatPromptPopup(
              question: question,
              onConfirm: () {
                widget.controller?.onNewChat?.call();
                if (question.isNotEmpty) {
                  _inputController.text = question;
                }
                _popupStreamController.add(null);
              },
              onDeny: () {
                _popupStreamController.add(null);
              },
            );
          },
        ),
      ],
    );
  }
}

class ChatInput extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onNewChat;
  final TextEditingController controller;

  const ChatInput({
    super.key,
    required this.onSend,
    required this.onNewChat,
    required this.controller,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      widget.controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                labelText: 'Example input',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              onSubmitted: (_) => _handleSend(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _handleSend,
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: widget.onNewChat,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
