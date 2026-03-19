import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel_controller.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list.dart';
import 'package:lingu/features/chat/logic/message/audio_message_input.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar_controller.dart';
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_type.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:lingu/features/chat/ui/record/record_display.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel.dart';
import 'package:lingu/features/text_message_input.dart';
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
  final ChatMessagesManager _messagesManager = di<ChatMessagesManager>();
  final PanelManager _panelManager = di<PanelManager>();
  final AudioMessageInput _audioMessageInput = di<AudioMessageInput>();
  final TextMessageInput _textMessageInput = di<TextMessageInput>();
  
  final BottomPanelController _bottomPanelController = BottomPanelController();

  @override
  void initState() {
    super.initState();
    _inputBarController.onTextSubmit = (text) {
      _messagesManager.addTextMessage(text: text, isUser: true);
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
        _textMessageInput.gainFocus();
      }
    });

    effect(() {
      _controller.setMessages(_messagesManager.messages.value.toList());
    });

    _audioMessageInput.amplitudeStream.listen((amplitude) {
      _recordController.updateAmplitude(amplitude);
    });

    _recordController.onStart = () {
      _audioMessageInput.startRecording();
    };

    _recordController.onStop = () {
      _audioMessageInput.stopRecording();
    };
    

    _recordController.onCancel = () {
      _audioMessageInput.cancelRecording();
    };

    _bottomPanelController.onClose = () {
      _panelManager.closePanel();
    };
  }

  @override
  void dispose() {
    super.dispose();

    _recordController.dispose();
    _audioMessageInput.dispose();
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
