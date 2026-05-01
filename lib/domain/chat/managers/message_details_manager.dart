import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/domain/chat/services/pronunciation_feedback_service.dart';
import 'package:lingu/domain/chat/services/statement_feedback_service.dart';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:signals/signals.dart';

class MessageDetailsManager {
  final PronunciationFeedbackService _pronunciationFeedbackService;
  final StatementFeedbackService _statementFeedbackService;

  MessageDetailsManager(
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
  );

  final _messageDetails = mapSignal<int, MessageDetails>({});
  ReadonlySignal<Map<int, MessageDetails>> get messageDetails =>
      _messageDetails;

  void setDetails(int messageId, MessageDetails details) {
    _messageDetails[messageId] = details;
  }

  
  Future<UserTextDetails> fetchTextFeedback(
    int messageId,
    List<UserTextInput> textInputs,
  ) async {
    final fullText = textInputs.map((e) => e.text).join(' ');

    final response = await _statementFeedbackService.analyze(
      statement: fullText,
      segments: textInputs,
    );

    final details = UserTextDetails(
      translatedText: response.translatedText,
      grammarFeedback: response.grammar,
      fluencyFeedback: response.fluency,
    );
    _messageDetails[messageId] = details;
    return details;
  }

  Future<UserAudioDetails> fetchAudioFeedback(
    int messageId,
    List<UserSpeechAudio> individualAudioUrls,
  ) async {
    final result = await _pronunciationFeedbackService.analyze(
      individualAudioUrls,
    );

    final response = await _statementFeedbackService.analyze(
      statement: result.rawTranscript,
      segments: individualAudioUrls,
    );

    final details = UserAudioDetails(
      transcription: result.rawTranscript,
      translatedText: response.translatedText,
      grammarFeedback: response.grammar,
      fluencyFeedback: response.fluency,
      pronunciationFeedback: result,
    );
    _messageDetails[messageId] = details;
    return details;
  }
}
