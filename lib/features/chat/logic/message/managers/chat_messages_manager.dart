import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/pronunciation/service/linux/linux_pronunciation_assessment_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_state.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:signals/signals.dart';
import 'package:http/http.dart' as http;

@Singleton(scope: 'chat')
class ChatMessagesManager {
  final PronunciationAssessmentCredentialsService _credentialsService;
  final MessageDetailsManager _messageDetailsManager;
  ChatMessagesManager(this._messageDetailsManager, this._credentialsService);
  
  final _messages = signal<List<ChatMessage>>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;

  int _nextId = 0;
  int _generateId() => _nextId++;

  void updateTextMessageFeedback(int id, FeedbackState<TextFeedbackResult> newState) {
    _messages.value = [
      for (final m in _messages.value)
        if (m is UserTextMessage && m.id == id)
          m.copyWith(feedbackResult: newState)
        else
          m
    ];
  }

  void updateAudioMessageFeedback(int id, FeedbackState<AudioFeedbackResult> newState) {
    _messages.value = [
      for (final m in _messages.value)
        if (m is UserAudioMessage && m.id == id)
          m.copyWith(feedbackResult: newState)
        else
          m
    ];
  }

  Future<void> addUserTextMessage({required String text}) async {
    final id = _generateId();
    final message = UserTextMessage(
      id: id,
      text: text, 
      feedbackResult: const FeedbackLoading(),
    );
    _messages.value = [..._messages.value, message];
    
    try {
      final summary = await _messageDetailsManager.fetchTextFeedback(id, text);
      updateTextMessageFeedback(id, FeedbackReady(summary));
    } catch (e) {
      updateTextMessageFeedback(id, FeedbackError(e));
    }
  }

  Future<void> addUserAudioMessage({
    required String audioUrl, 
    required Duration duration, 
    required List<UserSpeechAudio> individualAudioUrls,
  }) async {
    final id = _generateId();
    final message = UserAudioMessage(
      id: id,
      fullMergedAudioUrl: audioUrl, 
      duration: duration, 
      feedbackResult: const FeedbackLoading(),
      individualAudioUrls: individualAudioUrls,
    );
    _messages.value = [..._messages.value, message];

    try {
      final summary = await _messageDetailsManager.fetchAudioFeedback(id, audioUrl);
      updateAudioMessageFeedback(id, FeedbackReady(summary));
    } catch (e) {
      updateAudioMessageFeedback(id, FeedbackError(e));
    }
  }
}
