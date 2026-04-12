import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:signals/signals.dart';

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
    bool anyNative = textInputs.any((e) => !e.isTargetLanguage);

    if (anyNative) {
      final targetText = await _rephraseToTarget(fullText);
      _messageDetails[messageId] = UserTextMessageDetailsViewDto(
        translatedText: targetText,
        grammarFeedback: null,
        fluencyFeedback: null,
      );
      return;
    }

    final feedback = await _statementFeedbackService.analyze(fullText);
    _messageDetails[messageId] = UserTextMessageDetailsViewDto(
      translatedText: null,
      grammarFeedback: feedback.$2,
      fluencyFeedback: feedback.$1,
    );
  }

  Future<void> fetchAudioFeedback(
    int messageId,
    List<UserSpeechAudio> individualAudioUrls,
  ) async {
    final result =
        await _pronunciationFeedbackService.analyze(individualAudioUrls);
    bool anyNative = individualAudioUrls.any((e) => !e.isTargetLanguage);

    if (anyNative) {
      final targetText = await _rephraseToTarget(result.rawTranscript);
      _messageDetails[messageId] = UserAudioMessageDetailsViewDto(
        translatedText: targetText,
        grammarFeedback: null,
        fluencyFeedback: null,
        pronunciationFeedback: null,
      );
      return;
    }

    final feedback = await _statementFeedbackService.analyze(result.rawTranscript);
    _messageDetails[messageId] = UserAudioMessageDetailsViewDto(
      translatedText: null,
      grammarFeedback: feedback.$2,
      fluencyFeedback: feedback.$1,
      pronunciationFeedback: result,
    );
  }

  Future<String> _rephraseToTarget(String mixedText) async {
    final prompt = "Translate and rephrase the following text into ${_languages.target.name}. "
        "The input may contain a mix of ${_languages.native.name} and ${_languages.target.name}. "
        "Your goal is to provide a version fully in ${_languages.target.name} that is as close as possible to the user's original intent and tone. "
        "IMPORTANT: Provide ONLY the resulting text. Do not include any introductory remarks, explanations, or quotation marks. "
        "Text: \"$mixedText\"";
    final response = await _aiModel.generateContent(prompt: prompt);
    return response.trim();
  }
}
