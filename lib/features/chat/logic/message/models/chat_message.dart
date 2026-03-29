import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_result.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_state.dart';

sealed class ChatMessage {
  final int id;
  const ChatMessage({required this.id});
}

extension ChatMessageX on ChatMessage {
  bool get isUser => this is UserTextMessage || this is UserAudioMessage;

  bool get isClickable => switch (this) {
        UserTextMessage m => m.feedbackResult is FeedbackReady,
        UserAudioMessage m => m.feedbackResult is FeedbackReady,
        AITextMessage _ || AIAudioMessage _ => true,
      };
}

class UserTextMessage extends ChatMessage {
  final String text;
  final FeedbackState<TextFeedbackResult> feedbackResult;

  const UserTextMessage({
    required super.id,
    required this.text,
    this.feedbackResult = const FeedbackNone(),
  });

  UserTextMessage copyWith({
    int? id,
    String? text,
    FeedbackState<TextFeedbackResult>? feedbackResult,
  }) {
    return UserTextMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      feedbackResult: feedbackResult ?? this.feedbackResult,
    );
  }
}

class UserSpeechAudio {
  final String audioUrl;
  final bool isTargetLanguage;

  const UserSpeechAudio({
    required this.audioUrl,
    required this.isTargetLanguage,
  });
}

class UserAudioMessage extends ChatMessage {
  final String fullMergedAudioUrl;
  final List<UserSpeechAudio> individualAudioUrls;
  final Duration duration;
  final FeedbackState<AudioFeedbackResult> feedbackResult;

  const UserAudioMessage({
    required super.id,
    required this.fullMergedAudioUrl,
    required this.individualAudioUrls,
    required this.duration,
    this.feedbackResult = const FeedbackNone(),
  });

  UserAudioMessage copyWith({
    int? id,
    String? fullMergedAudioUrl,
    List<UserSpeechAudio>? individualAudioUrls,
    Duration? duration,
    FeedbackState<AudioFeedbackResult>? feedbackResult,
  }) {
    return UserAudioMessage(
      id: id ?? this.id,
      fullMergedAudioUrl: fullMergedAudioUrl ?? this.fullMergedAudioUrl,
      individualAudioUrls: individualAudioUrls ?? this.individualAudioUrls,
      duration: duration ?? this.duration,
      feedbackResult: feedbackResult ?? this.feedbackResult,
    );
  }
}

class AITextMessage extends ChatMessage {
  final String text;

  const AITextMessage({
    required super.id,
    required this.text,
  });
}

class AIAudioMessage extends ChatMessage {
  final String audioUrl;
  final Duration duration;

  const AIAudioMessage({
    required super.id,
    required this.audioUrl,
    required this.duration,
  });
}
