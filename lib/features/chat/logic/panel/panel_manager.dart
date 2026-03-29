import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback_result.dart';
import 'package:signals/signals_flutter.dart';

sealed class PanelState {}

sealed class MessageDetailsData {}
class NonePanelState implements PanelState {}

class ChatPanelState implements PanelState {}

class MicPanelState implements PanelState {}

class UserTextMessageData implements PanelState, MessageDetailsData {
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;

  UserTextMessageData({
    required this.grammarFeedback,
    required this.fluencyFeedback,
  });
}

class UserAudioMessageData implements PanelState, MessageDetailsData {
  final String transcript;
  final SentenceFeedback? grammarFeedback;
  final SentenceFeedback? fluencyFeedback;
  final PronunciationFeedbackResult? pronunciationFeedback;

  UserAudioMessageData({
    required this.transcript,
    required this.grammarFeedback,
    required this.fluencyFeedback,
    required this.pronunciationFeedback,
  });
}

class AITextMessageData implements PanelState, MessageDetailsData {
  final String? translation;

  AITextMessageData({required this.translation});
}

class AIAudioMessageData implements PanelState, MessageDetailsData {
  final String transcript;
  final String? translation;

  AIAudioMessageData({required this.transcript, required this.translation});
}

@Singleton(scope: 'chat')
class PanelManager {
  final MessageDetailsManager _messageDetailsManager;

  final _currentPanel = signal<PanelState>(NonePanelState());
  ReadonlySignal<PanelState> get currentPanel => _currentPanel;

  PanelManager(this._messageDetailsManager);

  void selectMessage(int messageId) {
    final details = _messageDetailsManager.messageDetails.value[messageId];
    if (details != null) {
      _currentPanel.value = details as PanelState;
    }
  }
  void openMicPanel() {
    _currentPanel.value = MicPanelState();
  }

  void closePanel() {
    _currentPanel.value = NonePanelState();
  }

  void openChatPanel() {
    _currentPanel.value = ChatPanelState();
  }
}
