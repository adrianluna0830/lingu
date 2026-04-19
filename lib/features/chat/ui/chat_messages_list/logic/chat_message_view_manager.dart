import 'dart:math';

import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_feedback_summary.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:signals/signals.dart';

class ChatMessageViewManager {
  final _messages = signal<List<MessageViewDto>>([]);
  ReadonlySignal<List<MessageViewDto>> get messages => _messages;

  void addMessage(ChatMessage message) {
    _messages.value = [..._messages.value, _mapToDto(message, null)];
  }

  void updateMessage(ChatMessage message, MessageDetailsViewDto details) {
    _messages.value = _messages.value.map((dto) {
      if (dto.id == message.id) {
        return _mapToDto(message, details);
      }
      return dto;
    }).toList();
  }

  static MessageViewDto _mapToDto(
    ChatMessage message,
    MessageDetailsViewDto? details,
  ) {
    return switch (message) {
      UserTextMessage m => UserTextMessageViewDto(
        chatMessage: m,
        feedbackSummary: _createTextSummary(
          details as UserTextMessageDetailsViewDto?,
        ),
      ),
      UserAudioMessage m => UserAudioMessageViewDto(
        chatMessage: m,
        feedbackSummary: _createAudioSummary(
          details as UserAudioMessageDetailsViewDto?,
        ),
      ),
      AITextMessage m => AITextMessageViewDto(
        chatMessage: m,
        translation: m.translation,
      ),
      AIAudioMessage m => AIAudioMessageViewDto(
        chatMessage: m,
        translation: m.translation,
      ),
    };
  }

  static TextFeedbackSummary? _createTextSummary(
    UserTextMessageDetailsViewDto? details,
  ) {
    if (details == null)
      return const TextFeedbackSummary(result: FeedbackResultEnum.processing);

    final grammar = _mapSeverity(details.grammarFeedback?.severity);
    final fluency = _mapSeverity(details.fluencyFeedback?.severity);
    final maxIndex = max(grammar.index, fluency.index);

    return TextFeedbackSummary(
      result: FeedbackResultEnum.values[maxIndex],
      translation: details.translatedText?.targetText,
    );
  }

  static AudioFeedbackSummary? _createAudioSummary(
    UserAudioMessageDetailsViewDto? details,
  ) {
    if (details == null) {
      return const AudioFeedbackSummary(
        result: FeedbackResultEnum.processing,
        transcription: '',
      );
    }

    final grammar = _mapSeverity(details.grammarFeedback?.severity);
    final fluency = _mapSeverity(details.fluencyFeedback?.severity);
    final pronunciation =
        details.pronunciationFeedback?.mostSevere ?? FeedbackResultEnum.none;

    final maxIndex = [
      grammar.index,
      fluency.index,
      pronunciation.index,
    ].reduce(max);

    return AudioFeedbackSummary(
      result: FeedbackResultEnum.values[maxIndex],
      transcription: details.pronunciationFeedback?.rawTranscript ?? '',
      translation: details.translatedText?.targetText,
    );
  }

  static FeedbackResultEnum _mapSeverity(ErrorSeverityEnum? severity) {
    if (severity == null) return FeedbackResultEnum.none;
    return switch (severity) {
      ErrorSeverityEnum.bad => FeedbackResultEnum.major,
      ErrorSeverityEnum.neutral => FeedbackResultEnum.minor,
    };
  }
}
