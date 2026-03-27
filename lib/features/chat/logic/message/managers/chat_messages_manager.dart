import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/managers/pronunciation_feedback_manager.dart';
import 'package:lingu/features/chat/logic/feedback/managers/text_feedback_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_state.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/logic/message/models/message.dart';
import 'package:lingu/features/chat/logic/message/managers/messages_manager.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class ChatMessagesManager {
  final MessagesManager _messagesManager;
  final PronunciationFeedbackManager _pronunciationFeedbackManager;
  final TextFeedbackManager _textFeedbackManager;

  ChatMessagesManager(
    this._messagesManager,
    this._pronunciationFeedbackManager,
    this._textFeedbackManager,
  );

  late final messages = computed<List<ChatMessage>>(() {
    final basicMessages = _messagesManager.messages.value;

    return basicMessages.map((msg) {
      if (msg.isUserMessage) {
        if (msg.content is TextMessage) {
          return UserTextMessage(
            msg,
            _textFeedbackManager.textFeedback(msg.id),
          );
        } else if (msg.content is AudioMessage) {
          final feedback = _pronunciationFeedbackManager.audioFeedback(msg.id);
          String transcript = '';
          if (feedback is AudioFeedbackResult) {
            transcript = feedback.pronunciation.transcript;
          }

          return UserAudioMessage(
            msg,
            feedback,
            transcript,
          );
        }
      } else {
        if (msg.content is TextMessage) {
          return AITextMessage(msg);
        } else if (msg.content is AudioMessage) {
          return AIAudioMessage(msg, ''); 
        }
      }
      return AITextMessage(msg); 
    }).toList();
  });
}
