import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/message/models/chat_panel_message.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_controller.dart';
import 'package:signals/signals_flutter.dart';

class ChatPanelInternalController {
  final ChatPanelController? controller;
  late final ListSignal<ChatPanelMessage> _messages;
  final void Function(String question)? onDirectQuestion;

  ChatPanelInternalController(this.controller, List<ChatPanelMessage> initialMessages, {this.onDirectQuestion})
  {
    _messages = listSignal<ChatPanelMessage>(initialMessages);
    if(controller != null)
    {
      controller!.onNewQuestion = (question) {
        if (_messages.value.isNotEmpty) {
          _newQuestionPrompt.value = question;
        } else {
          onDirectQuestion?.call(question);
        }
      };
    }
  }

  ReadonlySignal<List<ChatPanelMessage>> get messages => _messages;

  final _newQuestionPrompt = signal<String?>(null);
  ReadonlySignal<String?> get newQuestionPrompt => _newQuestionPrompt;

  void addUserMessage(String text) {
    final newMessage = ChatPanelMessage(text: text, isUser: true);
    _messages.value = [..._messages.value, newMessage];
    controller?.onNewUserMessage?.call(_messages.value);
  }

  void _startNewChat()
  {
    _messages.value = [];
    controller?.onNewChat?.call();
  }

  void confirmNewChat(TextEditingController inputController)
  {
    final question = _newQuestionPrompt.value;
    if (question != null && question.isNotEmpty) {
      inputController.text = question;
    }
    _startNewChat();
    _newQuestionPrompt.value = null;
  }

  void denyNewChat()
  {
    _newQuestionPrompt.value = null;
  }

  void triggerManualNewChat()
  {
    if (_messages.value.isNotEmpty) {
      _newQuestionPrompt.value = "";
    }
  }
}
