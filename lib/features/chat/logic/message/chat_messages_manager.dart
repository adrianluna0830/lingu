import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/user_feedback_analyzer.dart';
import 'package:lingu/features/chat/logic/feedback/user_text_feedback_process.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class ChatMessagesManager {
  final UserFeedbackAnalyzer _feedbackAnalyzer;

  ChatMessagesManager(this._feedbackAnalyzer);

  final _messages = listSignal<ChatMessage>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;

  Future<void> addTextMessage({required String text}) async {
    UserTextMessage newMessage = UserTextMessage(text: text);
    _messages.add(newMessage);
    final (fluency, grammar) = await _feedbackAnalyzer.analyze(text);
    TextFeedbackState progress = TextFeedbackResult(
      feedback: fluency,
      grammar: grammar,
    );
    _messages[_messages.value.length - 1] = newMessage.copyWith(
      feedbackProcess: progress,
    );
  }

  Future<void> addAudioMessage({
    required String audioUrl,
    required Duration duration,
  }) async {
    _messages.add(UserAudioMessage(audioUrl: audioUrl, duration: duration));
  }
}
