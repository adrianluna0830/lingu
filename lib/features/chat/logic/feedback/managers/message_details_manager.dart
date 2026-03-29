import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/sentence_feedback.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:signals/signals.dart';

@Singleton(scope: 'chat')
class MessageDetailsManager {
  final PronunciationFeedbackService _pronunciationFeedbackService;
  final StatementFeedbackService _statementFeedbackService;

  MessageDetailsManager(
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
  );

  final _messageDetails = mapSignal<int, MessageDetailsData>({});
  ReadonlySignal<Map<int, MessageDetailsData>> get messageDetails => _messageDetails;

  Future<TextFeedbackResult> fetchTextFeedback(int messageId, String text) async {
    await Future.delayed(const Duration(seconds: 1));
    
    final grammar = SentenceFeedback(
      correction: 'Dummy grammar correction',
      explanation: 'This is a dummy explanation for grammar.',
    );
    final fluency = SentenceFeedback(
      correction: 'Dummy fluency correction',
      explanation: 'This is a dummy explanation for fluency.',
    );

    _messageDetails[messageId] = UserTextMessageData(
      grammarFeedback: grammar,
      fluencyFeedback: fluency,
    );

    return TextFeedbackResult(
      fluency: FeedbackCorrectionLevel.neutral,
      grammar: FeedbackCorrectionLevel.neutral,
    );
  }

  Future<AudioFeedbackResult> fetchAudioFeedback(int messageId, String audioUrl, String transcript) async {
    await Future.delayed(const Duration(seconds: 1));

    final pronunciationResult = PronunciationFeedbackResult(
      transcript: transcript,
      accuracyScore: 90.0,
      fluencyScore: 85.0,
      completenessScore: 100.0,
      pronScore: 88.0,
    );

    final grammar = SentenceFeedback(
      correction: 'Dummy grammar correction',
      explanation: 'This is a dummy explanation for grammar.',
    );
    final fluency = SentenceFeedback(
      correction: 'Dummy fluency correction',
      explanation: 'This is a dummy explanation for fluency.',
    );

    _messageDetails[messageId] = UserAudioMessageData(
      transcript: transcript,
      grammarFeedback: grammar,
      fluencyFeedback: fluency,
      pronunciationFeedback: pronunciationResult,
    );

    return AudioFeedbackResult(
      pronunciation: FeedbackCorrectionLevel.neutral,
      fluency: FeedbackCorrectionLevel.neutral,
      grammar: FeedbackCorrectionLevel.neutral,
    );
  }
}
