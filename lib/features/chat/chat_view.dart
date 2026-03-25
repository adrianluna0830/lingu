import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel_controller.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar_controller.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_type.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:lingu/features/chat/ui/record/record_display.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel.dart';
import 'package:lingu/features/chat/logic/record_input_handler.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final InputBarController _inputBarController = InputBarController();
  final ChatMessagesListController _controller = ChatMessagesListController();
  final RecordController _recordController = RecordController();
  final BottomPanelController _bottomPanelController = BottomPanelController();
  final RecordInputHandler _recordInputHandler = di<RecordInputHandler>();
  final PanelManager _panelManager = di<PanelManager>();
  final UserMessagesHandler _userMessagesInputHandler = di<UserMessagesHandler>();

  @override
  void initState() {
    super.initState();
    _inputBarController.onTextSubmit = (text) {
      _userMessagesInputHandler.sendTextMessage(text: text);
    };

    _inputBarController.onStartRecording = () {
      _panelManager.openMicPanel();
    };

    _inputBarController.onChat = () {
      _panelManager.openChatPanel();
    };

    effect(() {
      _inputBarController.isFocused;
      if (_inputBarController.isFocused.value) {
        _panelManager.closePanel();
      }
    });

    effect(() {
      final chatMessages = _userMessagesInputHandler.messages.value.toList();
      _controller.setMessages(chatMessages);
    });

    _recordInputHandler.amplitudeStream.listen((amplitude) {
      _recordController.updateAmplitude(amplitude);
    });


    _recordController.onToggleRecording = (isPaused) {
      _recordInputHandler.toggleRecording();
    };

    _recordController.onToggleLanguage = (isTargetLanguage) {
      _recordInputHandler.toggleLanguage();
    };

    _recordController.onStart = () {
      _panelManager.openMicPanel();
      _recordInputHandler.startRecording();
    };

    _recordController.onStop = () {
      _panelManager.closePanel();
      _recordInputHandler.sendRecording();
    };
    

    _recordController.onCancel = () {
      _panelManager.closePanel();
      _recordInputHandler.cancelRecording();
    };

    _bottomPanelController.onClose = () {
      _panelManager.closePanel();
    };
  }

  @override
  void dispose() {
    super.dispose();

    _recordController.dispose();
    _recordInputHandler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat View')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: ChatMessagesList(controller: _controller)),
          if (_panelManager.currentPanel.watch(context) == PanelType.mic)
            Expanded(child: RecordDisplay(controller: _recordController)),
          if (_panelManager.currentPanel.watch(context) == PanelType.messageDetails)
            BottomPanel(controller: _bottomPanelController),
          if (_panelManager.currentPanel.watch(context) == PanelType.chat)
            BottomPanel(controller: _bottomPanelController),
          if (_panelManager.currentPanel.watch(context) != PanelType.mic)
            InputBar(_inputBarController),
        ],
      ),
    );
  }
}
