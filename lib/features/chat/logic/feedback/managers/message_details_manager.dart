import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/core/tts/core/synthesis_with_timepoints_response.dart';
import 'package:signals/signals_flutter.dart';

class MessageDetailsManager {
  final PronunciationFeedbackService _pronunciationFeedbackService;
  final StatementFeedbackService _statementFeedbackService;

  MessageDetailsManager(
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
  );

  final _messageDetails = mapSignal<int, MessageDetailsViewDto>({});
  ReadonlySignal<Map<int, MessageDetailsViewDto>> get messageDetails =>
      _messageDetails;

  void setDetails(int messageId, MessageDetailsViewDto details) {
    _messageDetails[messageId] = details;
  }

  void setAiAudioDetails(
    int messageId,
    List<SynthesisTimepoint> timepoints,
    Duration duration,
    String audioUrl,
  ) {
    _messageDetails[messageId] = AIAudioMessageDetailsViewDto(
      timepoints: timepoints,
      duration: duration,
      audioUrl: audioUrl,
    );
  }

  
  Future<UserTextMessageDetailsViewDto> fetchTextFeedback(
    int messageId,
    List<UserTextInput> textInputs,
  ) async {
    final fullText = textInputs.map((e) => e.text).join(' ');

    final response = await _statementFeedbackService.analyze(
      statement: fullText,
      segments: textInputs,
    );

    final dto = UserTextMessageDetailsViewDto(
      translatedText: response.translatedText,
      grammarFeedback: response.grammar,
      fluencyFeedback: response.fluency,
    );
    _messageDetails[messageId] = dto;
    return dto;
  }

  Future<UserAudioMessageDetailsViewDto> fetchAudioFeedback(
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

    final dto = UserAudioMessageDetailsViewDto(
      transcription: result.rawTranscript,
      translatedText: response.translatedText,
      grammarFeedback: response.grammar,
      fluencyFeedback: response.fluency,
      pronunciationFeedback: result,
    );
    _messageDetails[messageId] = dto;
    return dto;
  }
}
