import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/ai_audio_message_details.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/ai_text_message_details.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_state.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/logic/message_view_dto_computed.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar_controller.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:lingu/features/chat/ui/record/record_display.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/user_audio_message_details.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/user_text_message_details.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:lingu/features/chat/logic/input/audio_input_manager.dart';

@RoutePage()
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ChatMessagesManager _chatMessagesManager = di<ChatMessagesManager>();
  final InputBarController _inputBarController = InputBarController();
  final ChatMessagesListController _controller = ChatMessagesListController();
  final RecordController _recordController = RecordController();
  final BottomPanelController _bottomPanelController = BottomPanelController();
  final AudioInputManager _recordInputHandler = di<AudioInputManager>();
  final PanelManager _panelManager = di<PanelManager>();
  late final MessageViewDtoComputed _messageViewDtoComputed = di<MessageViewDtoComputed>();

  @override
  void initState() {
    super.initState();
    _inputBarController.onUserTextMessage = (text, individualTextInputs) {
      _chatMessagesManager.addUserTextMessage(text: text, individualTextInputs: individualTextInputs);
    };
    _inputBarController.onStartRecording = () {
      _panelManager.openMicPanel();
    };
    _inputBarController.onChat = () {
      _panelManager.openChatPanel();
    };
    _inputBarController.onFocusChange = (isFocused) {
      if (isFocused) {
        _panelManager.closePanel();
      }
    };
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
    _controller.onMessageTap = (message) {
      _panelManager.selectMessage(message.id);
    };
  }

  @override
  void dispose() {
    _recordInputHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelState = _panelManager.currentPanel.watch(context);
    final chatLanguages = di<ChatLanguages>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(title: const Text('Chat View')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ChatMessagesList(
                messages: [
                  AIAudioMessageViewDto(
                    chatMessage: const AIAudioMessage(
                      id: -2,
                      transcription: 'This is a test AI transcription for audio messages.',
                      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                      duration: Duration(seconds: 5),
                    ),
                    translation: null, // Test "Cargando..."
                  ),
                  AITextMessageViewDto(
                    chatMessage: const AITextMessage(
                      id: -1,
                      text: 'This is a dummy AI message to test the UI design.',
                    ),
                    translation: 'Este es un mensaje de IA ficticio para probar el diseño de la interfaz.',
                  ),
                  ..._messageViewDtoComputed.watch(context),
                ],
                controller: _controller,
              ),
            ),
            if (panelState is MicPanelState)
              Expanded(
                child: RecordDisplay(
                  controller: _recordController,
                  amplitudeStream: _recordInputHandler.amplitudeStream
                      .map((a) => (a.value, a.maxValue)),
                  nativeLocale: chatLanguages.native,
                  targetLocale: chatLanguages.target,
                ),
              ),
            if (panelState is ChatPanelState)
              SizedBox(
                height: 200,
                child: BottomPanel(
                    controller: _bottomPanelController,
                    child: const SizedBox.shrink()),
              ),
            if (panelState is MessageDetailsPanelState)
              SizedBox(
                height: 300,
                child: Builder(builder: (context) {
                  final data = panelState.data;
                  if (data is UserTextMessageDetailsViewDto) {
                    return BottomPanel(
                      controller: _bottomPanelController,
                      child: UserTextMessageDetails(data: data),
                    );
                  } else if (data is UserAudioMessageDetailsViewDto) {
                    return BottomPanel(
                      controller: _bottomPanelController,
                      child: UserAudioMessageDetails(data: data),
                    );
                  } else if (data is AITextMessageDetailsViewDto) {
                    return BottomPanel(
                      controller: _bottomPanelController,
                      child: AITextMessageDetails(data: data),
                    );
                  } else if (data is AIAudioMessageDetailsViewDto) {
                    return BottomPanel(
                      controller: _bottomPanelController,
                      child: AIAudioMessageDetails(data: data),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
            if (panelState is! MicPanelState)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InputBar(
                  _inputBarController,
                  nativeLocale: chatLanguages.native,
                  targetLocale: chatLanguages.target,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
