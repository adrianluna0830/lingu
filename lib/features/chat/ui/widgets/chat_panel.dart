import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_controller.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_internal_controller.dart';
import 'package:lingu/features/chat/logic/message/models/chat_panel_message.dart';
import 'package:lingu/features/chat/ui/widgets/chat_panel_messages.dart';
import 'package:lingu/features/chat/ui/chat_view.dart';
import 'package:lingu/features/chat/ui/widgets/new_chat_prompt_popup.dart';
import 'package:signals/signals_flutter.dart';

class ChatPanel extends StatefulWidget {
  final List<ChatPanelMessage> messages;
  final ChatPanelController? controller;
  final String? initialQuestion;

  const ChatPanel({super.key, required this.messages, this.controller, this.initialQuestion});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final TextEditingController _inputController = TextEditingController();
  late final ChatPanelInternalController _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = ChatPanelInternalController(
      widget.controller, 
      widget.messages,
      onDirectQuestion: (question) {
        _inputController.text = question;
      },
    );
    if (widget.initialQuestion != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.controller?.tryStartNewChatWithQuestion(widget.initialQuestion!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPrompt = _internalController.newQuestionPrompt.watch(context);
    final messages = _internalController.messages.watch(context);

    return Stack(
      children: [
        Column(
          children: [
            ChatPanelMessages(messages: messages),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        labelText: 'Example input',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        final text = _inputController.text.trim();
                        if (text.isNotEmpty) {
                          _internalController.addUserMessage(text);
                          _inputController.clear();
                        }
                      },
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
                      onPressed: () => _internalController.triggerManualNewChat(),
                      icon: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (currentPrompt != null)
          Positioned.fill(
            child: NewChatPromptPopup(
              question: currentPrompt,
              onConfirm: () => _internalController.confirmNewChat(_inputController),
              onDeny: () => _internalController.denyNewChat(),
            ),
          ),
      ],
    );
  }
}
