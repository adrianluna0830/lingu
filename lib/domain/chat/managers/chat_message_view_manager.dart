import 'dart:math';

import 'package:lingu/domain/chat/models/enums/error_severity_enum.dart';
import 'package:lingu/domain/chat/models/enums/feedback_result_enum.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/domain/chat/models/feedback/message_feedback_summary.dart';
import 'package:lingu/domain/chat/models/chat/chat_message.dart';
import 'package:lingu/presentation/screens/chat/models/message_view_dto.dart';
import 'package:signals/signals.dart';

class ChatMessageViewManager {
  final _messages = signal<List<MessageViewDto>>([]);
  ReadonlySignal<List<MessageViewDto>> get messages => _messages;

  void addMessage(ChatMessageModel message) {
    _messages.value = [..._messages.value, _mapToDto(message, null)];
  }

  void updateMessage(ChatMessageModel message, MessageDetails details) {
    _messages.value = _messages.value.map((dto) {
      if (dto.id == message.id) {
        return _mapToDto(message, details);
      }
      return dto;
    }).toList();
  }

  static MessageViewDto _mapToDto(
    ChatMessageModel message,
    MessageDetails? details,
  ) {
    return switch (message) {
      UserTextMessageModel m => UserTextMessageViewDto(
        chatMessage: m,
        feedbackSummary: _createTextSummary(
          details as UserTextDetails?,
        ),
      ),
      UserAudioMessageModel m => UserAudioMessageViewDto(
        chatMessage: m,
        feedbackSummary: _createAudioSummary(
          details as UserAudioDetails?,
        ),
      ),
      AITextMessageModel m => AITextMessageViewDto(
        chatMessage: m,
        translation: m.translation,
      ),
      AIAudioMessageModel m => AIAudioMessageViewDto(
        id: m.id,
        transcription: m.transcript,
        translation: m.translation,
        speechAudio: SpeechAudio(
          timepoints: m.timepoints,
          duration: m.duration,
          audioUrl: m.audioUrl,
        ),
      ),
    };
  }

  static TextFeedbackSummary? _createTextSummary(
    UserTextDetails? details,
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
    UserAudioDetails? details,
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
