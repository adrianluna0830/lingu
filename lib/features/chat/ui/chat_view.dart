import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/input/audio_input_manager.dart';
import 'package:lingu/features/chat/ui/widgets/chat_panel.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_controller.dart';
import 'package:lingu/features/chat/logic/message/models/chat_panel_message.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel_controller.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/ai_audio_message_details.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_state.dart';
import 'package:lingu/features/chat/logic/chatbot/chat_orchestrator.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar_controller.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:lingu/features/chat/ui/record/record_display.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/user_audio_message_details.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/user_text_message_details.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_manager.dart';
import 'package:lingu/features/word/word_selection_dialog.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';

@RoutePage()
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final MessageDetailsManager _messageDetailsManager = di<MessageDetailsManager>();
  final InputBarController _inputBarController = InputBarController();
  final ChatMessagesListController _controller = ChatMessagesListController();
  final RecordController _recordController = RecordController();
  final BottomPanelController _bottomPanelController = BottomPanelController();
  final ChatPanelController _chatPanelController = ChatPanelController();
  final AudioInputManager _recordInputHandler = di<AudioInputManager>();
  final PanelManager _panelManager = di<PanelManager>();
  final ChatPanelManager _chatPanelManager = di<ChatPanelManager>();
  late final ChatOrchestrator _orchestrator = di<ChatOrchestrator>();

  @override
  void initState() {
    super.initState();
    _chatPanelController.onNewUserMessage = (text) => _chatPanelManager.onNewUserMessage(text);
    _chatPanelController.onNewChat = () => _chatPanelManager.onNewChat();

    _inputBarController.onUserTextMessage = (text, individualTextInputs) {
      _orchestrator.handleUserTextMessage(text: text, individualTextInputs: individualTextInputs);
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
    _controller.onAITranslationTap = (message) {
      if (message is AITextMessageViewDto) {
        _orchestrator.handleFetchTranslation(message.id, message.chatMessage.text);
      } else if (message is AIAudioMessageViewDto) {
        _orchestrator.handleFetchTranslation(message.id, message.chatMessage.transcript);
      }
    };
_controller.onWordInfoTap = (message) async {
  final content = switch (message) {
    UserTextMessageViewDto m => m.feedbackSummary!.translation!,
    UserAudioMessageViewDto m => m.feedbackSummary!.translation!,
    AITextMessageViewDto m => m.chatMessage.text,
    AIAudioMessageViewDto m => m.chatMessage.transcript,
  };

  final result = await showWordSelectionDialog(context, content);

  if (result != null) {
    final languages = di<ChatLanguages>();
    if (mounted) {
      context.router.push(WordFetchRoute(
        word: result.word,
        wordInContext: result.context,
        learningLocale: languages.target,
        nativeLocale: languages.native,
      ));
    }
  }
};

    _controller.onChatMessageTap = (message) {
      String? content = switch (message) {
        UserTextMessageViewDto m => m.chatMessage.text,
        UserAudioMessageViewDto m => m.feedbackSummary?.transcription,
        AITextMessageViewDto m => m.chatMessage.text,
        AIAudioMessageViewDto m => m.chatMessage.transcript,
      };

      _panelManager.openChatPanel(initialMessage: content);
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
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: ChatMessagesList(
                    messages:_orchestrator.messages.watch(context),
                    controller: _controller,
                  ),
                ),
                if (panelState is! MicPanelState)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InputBar(_inputBarController, nativeLocale: chatLanguages.native, targetLocale: chatLanguages.target),
                  ),
              ],
            ),
            if (panelState is MicPanelState)
              RecordDisplay(
                controller: _recordController,
                amplitudeStream: _recordInputHandler.amplitudeStream.map((a) => (a.value, a.maxValue)),
                nativeLocale: chatLanguages.native,
                targetLocale: chatLanguages.target,
              ),
            BottomPanel(
              isVisible: panelState is ChatPanelState || panelState is MessageDetailsPanelState,
              controller: _bottomPanelController,
              child: Builder(
                builder: (context) {
                  if (panelState is MessageDetailsPanelState) {
                    final data = panelState.data;
                    if (data is UserTextMessageDetailsViewDto) {
                      return UserTextMessageDetails(data: data);
                    } else if (data is UserAudioMessageDetailsViewDto) {
                      return UserAudioMessageDetails(data: data);
                    } else if (data is AIAudioMessageDetailsViewDto) {
                      return AIAudioMessageDetails(data: data);
                    }
                  }
                  if (panelState is ChatPanelState) {
                    return ChatPanel(
                      controller: _chatPanelController,
                      messages: _chatPanelManager.messages.watch(context),
                      initialMessage: panelState.initialMessage,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
