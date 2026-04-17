import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:signals/signals_flutter.dart';

class MessageDetailsManager {
  final ChatMessagesManager _chatMessagesManager;
  final PronunciationFeedbackService _pronunciationFeedbackService;
  final StatementFeedbackService _statementFeedbackService;
  final IAIService _aiModel;
  final ChatLanguages _languages;

  MessageDetailsManager(
    this._aiModel,
    this._chatMessagesManager,
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
    this._languages,
  );

  

  final _messageDetails = mapSignal<int, MessageDetailsViewDto>({});
  ReadonlySignal<Map<int, MessageDetailsViewDto>> get messageDetails =>
      _messageDetails;

  Future<MessageDetailsViewDto?> fetchTranslation(int messageId, String content) async {
    if (_messageDetails.containsKey(messageId)) return _messageDetails[messageId]; 
    final String prompt = "Translate the following text to ${_languages.native.bcp47}, the output should be only a translation: $content ";
    final response = await _aiModel.generateContent(prompt: prompt);

    final message = _chatMessagesManager.messages.value.firstWhere((e) => e.id == messageId);
    final MessageDetailsViewDto details;
    if (message is AIAudioMessage) {
      details = AIAudioMessageDetailsViewDto(
        transcript: message.transcription,
        translation: response,
      );
    } else {
      details = AITextMessageDetailsViewDto(translation: response);
    }
    _messageDetails[messageId] = details;
    return details;
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
    final result =
        await _pronunciationFeedbackService.analyze(individualAudioUrls);

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
