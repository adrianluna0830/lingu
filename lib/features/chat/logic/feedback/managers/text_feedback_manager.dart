import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_state.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/message/message.dart';
import 'package:lingu/features/chat/logic/message/messages_manager.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class TextFeedbackManager {
  final MessagesManager _messagesManager;
  final StatementFeedbackService _statementFeedbackService;

  final _textFeedbacks = mapSignal<int, TextFeedbackState>({});

  // Nuevo método para obtener feedback de texto de forma segura
  TextFeedbackState textFeedback(int id) {
    return _textFeedbacks[id] ?? const AnalyzingText();
  }

  TextFeedbackManager(
    this._messagesManager,
    this._statementFeedbackService,
  ) {
    effect(() {
      final messages = _messagesManager.messages.value;
      for (final message in messages) {
        if (message.isUserMessage && 
            message.content is TextMessage && 
            !_textFeedbacks.containsKey(message.id)) {
          _processTextFeedback(message);
        }
      }
    });
  }

  Future<void> _processTextFeedback(Message message) async {
    _textFeedbacks[message.id] = const AnalyzingText();
    
    final textContent = message.content as TextMessage;
    final result = await _statementFeedbackService.analyze(textContent.text);

    _textFeedbacks[message.id] = TextFeedbackResult(
      fluency: result.$1,
      grammar: result.$2,
    );
  }
}
