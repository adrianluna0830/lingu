import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_manager.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_manager.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:signals/signals.dart';

class MessageDetailsManager {
  final ChatMessagesManager _chatMessagesManager;
  final PronunciationFeedbackManager _pronunciationFeedbackService;
  final StatementFeedbackManager _statementFeedbackService;

  MessageDetailsManager(
    this._chatMessagesManager,
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
  ) {
    _chatMessagesManager.onNewMessage.listen((message) {
      if (!message.isUser) return;
      if (message is UserTextMessage) {
        fetchTextFeedback(message.id, message.text);
      } else if (message is UserAudioMessage) {
        fetchAudioFeedback(message.id, message.individualAudioFilePaths);
      }
    });
  }

  final _messageDetails = mapSignal<int, MessageDetailsData>({});
  ReadonlySignal<Map<int, MessageDetailsData>> get messageDetails =>
      _messageDetails;

  Future<void> fetchTextFeedback(int messageId, String text) async {
    final result = await _statementFeedbackService.analyze(text);
    print('Feedback obtenido para mensaje $messageId: $result');

  }

  Future<void> fetchAudioFeedback(
    int messageId,
    List<UserSpeechAudio> individualAudioUrls,
  ) async {
    final result = await _pronunciationFeedbackService.analyze(individualAudioUrls);
  }
}
