import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_state.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/message/models/message.dart';
import 'package:lingu/features/chat/logic/message/managers/messages_manager.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class PronunciationFeedbackManager {
  final MessagesManager _messagesManager;
  final PronunciationFeedbackService _pronunciationFeedbackService;
  final StatementFeedbackService _statementFeedbackService;

  final _audioFeedbacks = mapSignal<int, AudioFeedbackState>({});
  
  // Nuevo método para obtener feedback de forma segura
  AudioFeedbackState audioFeedback(int id) {
    return _audioFeedbacks[id] ?? const AnalyzingAudio();
  }

  PronunciationFeedbackManager(
    this._messagesManager,
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
  ) {
    effect(() {
      final messages = _messagesManager.messages.value;
      for (final message in messages) {
        if (message.isUserMessage && 
            message.content is AudioMessage && 
            !_audioFeedbacks.containsKey(message.id)) {
          _processAudioFeedback(message);
        }
      }
    });
  }

  Future<void> _processAudioFeedback(Message message) async {
    _audioFeedbacks[message.id] = const AnalyzingAudio();
    
    final audioContent = message.content as AudioMessage;
    final pronunciationResult = await _pronunciationFeedbackService.getFeedback(audioContent.audioUrl);
    final statementResult = await _statementFeedbackService.analyze(pronunciationResult.transcript);

    _audioFeedbacks[message.id] = AudioFeedbackResult(
      pronunciation: pronunciationResult,
      fluency: statementResult.$1,
      grammar: statementResult.$2,
    );
  }
}
