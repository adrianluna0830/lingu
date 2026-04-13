import 'dart:math';

import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/error_severity_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_feedback_summary.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:signals/signals_flutter.dart';

class MessageViewDtoComputed extends Computed<List<MessageViewDto>> {
  MessageViewDtoComputed({
    required ChatMessagesManager chatMessagesManager,
    required MessageDetailsManager messageDetailsManager,
  }) : super(() {
          final messages = chatMessagesManager.messages.value;
          final detailsMap = messageDetailsManager.messageDetails.value;

          return messages.map((message) {
            final details = detailsMap[message.id];
            return _mapToDto(message, details);
          }).toList();
        });

  static MessageViewDto _mapToDto(ChatMessage message, MessageDetailsViewDto? details) {
    return switch (message) {
      UserTextMessage m => UserTextMessageViewDto(
          chatMessage: m,
          feedbackSummary: _createTextSummary(details as UserTextMessageDetailsViewDto?),
        ),
      UserAudioMessage m => UserAudioMessageViewDto(
          chatMessage: m,
          feedbackSummary: _createAudioSummary(details as UserAudioMessageDetailsViewDto?),
        ),
      AITextMessage m => AITextMessageViewDto(chatMessage: m, translation: null),
      AIAudioMessage m => AIAudioMessageViewDto(chatMessage: m, translation: null),
    };
  }

  static TextFeedbackSummary? _createTextSummary(UserTextMessageDetailsViewDto? details) {
    if (details == null) return null;

    final grammar = _mapSeverity(details.grammarFeedback?.severity);
    final fluency = _mapSeverity(details.fluencyFeedback?.severity);
    final maxIndex = max(grammar.index, fluency.index);

    return TextFeedbackSummary(
      result: FeedbackResultEnum.values[maxIndex],
      translation: details.translatedText?.targetText,
    );
  }

  static AudioFeedbackSummary? _createAudioSummary(UserAudioMessageDetailsViewDto? details) {
    if (details == null) return null;

    final grammar = _mapSeverity(details.grammarFeedback?.severity);
    final fluency = _mapSeverity(details.fluencyFeedback?.severity);
    final pronunciation = details.pronunciationFeedback?.mostSevere ?? FeedbackResultEnum.none;

    final maxIndex = [grammar.index, fluency.index, pronunciation.index].reduce(max);

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
