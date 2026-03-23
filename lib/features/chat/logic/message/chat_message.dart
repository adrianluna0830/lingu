import 'package:lingu/features/chat/logic/feedback/user_audio_feedback_process.dart';
import 'package:lingu/features/chat/logic/feedback/user_text_feedback_process.dart';

sealed class ChatMessage {
  final int id;

  const ChatMessage(this.id);
}

class UserTextMessage extends ChatMessage {
  final String text;
  final TextFeedbackState feedbackProcess;

  const UserTextMessage({
    required int id,
    required this.text,
    this.feedbackProcess = const AnalyzingText(),
  }) : super(id);

  UserTextMessage copyWith({
    int? id,
    String? text,
    TextFeedbackState? feedbackProcess,
  }) {
    return UserTextMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      feedbackProcess: feedbackProcess ?? this.feedbackProcess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserTextMessage &&
        other.id == id &&
        other.text == text &&
        other.feedbackProcess == feedbackProcess;
  }

  @override
  int get hashCode => Object.hash(id, text, feedbackProcess);
}

class UserAudioMessage extends ChatMessage {
  final String audioUrl;
  final Duration duration;
  final AudioFeedbackState feedbackProcess;

  const UserAudioMessage({
    required int id,
    required this.audioUrl,
    required this.duration,
    this.feedbackProcess = const AnalyzingAudio(),
  }) : super(id);

  UserAudioMessage copyWith({
    int? id,
    String? audioUrl,
    Duration? duration,
    AudioFeedbackState? feedbackProcess,
  }) {
    return UserAudioMessage(
      id: id ?? this.id,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      feedbackProcess: feedbackProcess ?? this.feedbackProcess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserAudioMessage &&
        other.id == id &&
        other.audioUrl == audioUrl &&
        other.duration == duration &&
        other.feedbackProcess == feedbackProcess;
  }

  @override
  int get hashCode => Object.hash(id, audioUrl, duration, feedbackProcess);
}

class AITextMessage extends ChatMessage {
  final String text;

  const AITextMessage({
    required int id,
    required this.text,
  }) : super(id);

  AITextMessage copyWith({
    int? id,
    String? text,
  }) {
    return AITextMessage(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AITextMessage &&
        other.id == id &&
        other.text == text;
  }

  @override
  int get hashCode => Object.hash(id, text);
}

class AIAudioMessage extends ChatMessage {
  final String audioUrl;
  final Duration duration;

  const AIAudioMessage({
    required int id,
    required this.audioUrl,
    required this.duration,
  }) : super(id);

  AIAudioMessage copyWith({
    int? id,
    String? audioUrl,
    Duration? duration,
  }) {
    return AIAudioMessage(
      id: id ?? this.id,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AIAudioMessage &&
        other.id == id &&
        other.audioUrl == audioUrl &&
        other.duration == duration;
  }

  @override
  int get hashCode => Object.hash(id, audioUrl, duration);
}