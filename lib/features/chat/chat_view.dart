import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/input/audio_input_handler.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel_controller.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar_controller.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:lingu/features/chat/ui/record/record_display.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';

class MessageViewDTOComputed extends Computed<List<MessageViewDTO>> {
  MessageViewDTOComputed(
      {required ChatMessagesManager chatMessagesManager,
      required MessageDetailsManager messageDetailsManager})
      : super(() {
          final messages = chatMessagesManager.messages.value;
          final messageDetails = messageDetailsManager.messageDetails.value;
          List<MessageViewDTO> dtos = [];
          for (var message in messages) {
            final details = messageDetails[message.id];
            if (message is UserTextMessage) {
              final userTextDetails =
                  details is UserTextMessageData ? details : null;
              dtos.add(UserTextMessageViewDTO(
                id: message.id,
                text: message.text,
                correction: userTextDetails?.grammarFeedback?.correction,
                grammarErrorSeverity: userTextDetails?.grammarFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
                fluencyCorrection: userTextDetails?.fluencyFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
              ));
            } else if (message is UserAudioMessage) {
              final userAudioDetails =
                  details is UserAudioMessageData ? details : null;
              dtos.add(UserAudioMessageViewDTO(
                id: message.id,
                audioUrl: message.fullMergedAudioFilePath,
                duration: message.duration,
                correction: userAudioDetails?.grammarFeedback?.correction,
                grammarErrorSeverity: userAudioDetails?.grammarFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
                fluencyCorrection: userAudioDetails?.fluencyFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
                pronunciationErrorSeverity:
                    userAudioDetails?.pronunciationFeedback != null
                        ? FeedbackResultEnum.none
                        : null,
              ));
            } else if (message is AITextMessage) {
              final aiTextDetails =
                  details is AITextMessageData ? details : null;
              dtos.add(AITextMessageViewDTO(
                id: message.id,
                text: message.text,
                translation: aiTextDetails?.translation,
              ));
            } else if (message is AIAudioMessage) {
              final aiAudioDetails =
                  details is AIAudioMessageData ? details : null;
              dtos.add(AIAudioMessageViewDTO(
                id: message.id,
                audioUrl: message.audioUrl,
                duration: message.duration,
                transcript: message.audioUrl, // Using audioUrl as placeholder
                translation: aiAudioDetails?.translation,
              ));
            }
          }
          return dtos;
        });
}

enum FeedbackResultEnum {
  none,
  minor,
  major,
}

sealed class MessageViewDTO {
  final int id;
  MessageViewDTO({required this.id});
}

class UserTextMessageViewDTO extends MessageViewDTO {
  final String text;
  final String? correction;
  final FeedbackResultEnum? grammarErrorSeverity;
  final FeedbackResultEnum? fluencyCorrection;

  UserTextMessageViewDTO({
    required super.id,
    required this.text,
    required this.correction,
    required this.grammarErrorSeverity,
    required this.fluencyCorrection,
  });
}

class UserAudioMessageViewDTO extends MessageViewDTO {
  final String audioUrl;
  final Duration duration;
  final String? correction;
  final FeedbackResultEnum? grammarErrorSeverity;
  final FeedbackResultEnum? fluencyCorrection;
  final FeedbackResultEnum? pronunciationErrorSeverity;

  UserAudioMessageViewDTO({
    required super.id,
    required this.audioUrl,
    required this.duration,
    required this.correction,
    required this.grammarErrorSeverity,
    required this.fluencyCorrection,
    required this.pronunciationErrorSeverity,
  });
}

class AITextMessageViewDTO extends MessageViewDTO {
  final String text;
  final String? translation;

  AITextMessageViewDTO({
    required super.id,
    required this.text,
    required this.translation,
  });
}

class AIAudioMessageViewDTO extends MessageViewDTO {
  final String audioUrl;
  final Duration duration;
  final String transcript;
  final String? translation;

  AIAudioMessageViewDTO({
    required super.id,
    required this.audioUrl,
    required this.duration,
    required this.transcript,
    required this.translation,
  });
}

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
  final AudioInputHandler _recordInputHandler = di<AudioInputHandler>();
  final PanelManager _panelManager = di<PanelManager>();
  late final MessageViewDTOComputed _messageViewDTOComputed = di<MessageViewDTOComputed>();

  @override
  void initState() {
    super.initState();
    _inputBarController.onTextSubmit = (text) {
      _chatMessagesManager.addUserTextMessage(text: text);
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
    _controller.onMessageTap = (message) {
      _panelManager.selectMessage(message.id);
    };
  }

  @override
  void dispose() {
    _recordController.dispose();
    _recordInputHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelState = _panelManager.currentPanel.watch(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Chat View')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ChatMessagesList(
              messages: _messageViewDTOComputed.watch(context),
              controller: _controller,
            ),
          ),
          if (panelState is MicPanelState)
            Expanded(child: RecordDisplay(controller: _recordController)),
          if (panelState is ChatPanelState)
            BottomPanel(
                controller: _bottomPanelController,
                child: const SizedBox(height: 200)),
          if (panelState is UserTextMessageData)
            BottomPanel(
              controller: _bottomPanelController,
              child: UserTextMessageDetails(
                grammarFeedback: panelState.grammarFeedback,
                fluencyFeedback: panelState.fluencyFeedback,
              ),
            ),
          if (panelState is UserAudioMessageData)
            BottomPanel(
              controller: _bottomPanelController,
              child: UserAudioMessageDetails(
                transcript: panelState.transcript,
                grammarFeedback: panelState.grammarFeedback,
                fluencyFeedback: panelState.fluencyFeedback,
              ),
            ),
          if (panelState is AITextMessageData)
            BottomPanel(
              controller: _bottomPanelController,
              child: AITextMessageDetails(
                translation: panelState.translation,
              ),
            ),
          if (panelState is AIAudioMessageData)
            BottomPanel(
              controller: _bottomPanelController,
              child: AIAudioMessageDetails(
                transcript: panelState.transcript,
                translation: panelState.translation,
              ),
            ),
          if (panelState is! MicPanelState)
            InputBar(_inputBarController),
        ],
      ),
    );
  }
}

class UserTextMessageDetails extends StatelessWidget {
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;

  const UserTextMessageDetails({
    super.key,
    required this.grammarFeedback,
    required this.fluencyFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Text(
          'Grammar: ${grammarFeedback?.correction ?? "Perfect"}\n'
          'Fluency: ${fluencyFeedback?.correction ?? "Perfect"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class UserAudioMessageDetails extends StatelessWidget {
  final String transcript;
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;

  const UserAudioMessageDetails({
    super.key,
    required this.transcript,
    required this.grammarFeedback,
    required this.fluencyFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Text(
          'Transcript: $transcript\n'
          'Grammar: ${grammarFeedback?.correction ?? "Perfect"}\n'
          'Fluency: ${fluencyFeedback?.correction ?? "Perfect"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class AITextMessageDetails extends StatelessWidget {
  final String? translation;

  const AITextMessageDetails({
    super.key,
    this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Text(
          'Translation: ${translation ?? "No translation available"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

class AIAudioMessageDetails extends StatelessWidget {
  final String transcript;
  final String? translation;

  const AIAudioMessageDetails({
    super.key,
    required this.transcript,
    this.translation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Text(
          'Transcript: $transcript\n'
          'Translation: ${translation ?? "No translation available"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
