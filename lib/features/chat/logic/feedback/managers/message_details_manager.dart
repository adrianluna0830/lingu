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
  final IAiService _aiModel;
  final ChatLanguages _languages;

  MessageDetailsManager(
    this._aiModel,
    this._chatMessagesManager,
    this._pronunciationFeedbackService,
    this._statementFeedbackService,
    this._languages,
  ) {
    _chatMessagesManager.onNewMessage.listen((message) {
      if (!message.isUser) return;
      if (message is UserTextMessage) {
        fetchTextFeedback(message.id, message.individualTextInputs);
      } else if (message is UserAudioMessage) {
        fetchAudioFeedback(message.id, message.individualAudioFilePaths);
      }
    });
  }

  final _messageDetails = mapSignal<int, MessageDetailsViewDto>({});
  ReadonlySignal<Map<int, MessageDetailsViewDto>> get messageDetails =>
      _messageDetails;

  Future<void> fetchTextFeedback(
    int messageId,
    List<UserTextInput> textInputs,
  ) async {
    final fullText = textInputs.map((e) => e.text).join(' ');

    final response = await _statementFeedbackService.analyze(
      statement: fullText,
      segments: textInputs,
    );

    _messageDetails[messageId] = UserTextMessageDetailsViewDto(
      translatedText: response.translatedText,
      grammarFeedback: response.grammar,
      fluencyFeedback: response.fluency,
    );
  }

  Future<void> fetchAudioFeedback(
    int messageId,
    List<UserSpeechAudio> individualAudioUrls,
  ) async {
    final result =
        await _pronunciationFeedbackService.analyze(individualAudioUrls);

    final response = await _statementFeedbackService.analyze(
      statement: result.rawTranscript,
      segments: individualAudioUrls,
    );

    _messageDetails[messageId] = UserAudioMessageDetailsViewDto(
      translatedText: response.translatedText,
      grammarFeedback: response.grammar,
      fluencyFeedback: response.fluency,
      pronunciationFeedback: result,
    );
  }
}
