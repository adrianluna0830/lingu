import 'package:lingu/features/chat/logic/feedback/user_audio_feedback_process.dart';
import 'package:lingu/features/chat/logic/feedback/user_text_feedback_process.dart';

sealed class ChatMessage {}

class UserTextMessage extends ChatMessage {
  final String text;
  final TextFeedbackState feedbackProcess;

  UserTextMessage({
    required this.text,
    this.feedbackProcess = const AnalyzingText(),
  });

  UserTextMessage copyWith({
    String? text,
    TextFeedbackState? feedbackProcess,
  }) {
    return UserTextMessage(
      text: text ?? this.text,
      feedbackProcess: feedbackProcess ?? this.feedbackProcess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserTextMessage &&
      other.text == text &&
      other.feedbackProcess == feedbackProcess;
  }
}

class UserAudioMessage extends ChatMessage {
  final String audioUrl;
  final Duration duration;
  final AudioFeedbackState feedbackProcess;

  UserAudioMessage({
    required this.audioUrl,
    required this.duration,
    this.feedbackProcess = const AnalyzingAudio(),
  });

  UserAudioMessage copyWith({
    String? audioUrl,
    Duration? duration,
    AudioFeedbackState? feedbackProcess,
  }) {
    return UserAudioMessage(
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      feedbackProcess: feedbackProcess ?? this.feedbackProcess,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserAudioMessage &&
      other.audioUrl == audioUrl &&
      other.duration == duration &&
      other.feedbackProcess == feedbackProcess;
  }
}

class AITextMessage extends ChatMessage {
  final String text;

  AITextMessage({required this.text});

  AITextMessage copyWith({
    String? text,
  }) {
    return AITextMessage(
      text: text ?? this.text,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AITextMessage &&
      other.text == text;
  }
}

class AIAudioMessage extends ChatMessage {
  final String audioUrl;
  final Duration duration;

  AIAudioMessage({
    required this.audioUrl,
    required this.duration,
  });

  AIAudioMessage copyWith({
    String? audioUrl,
    Duration? duration,
  }) {
    return AIAudioMessage(
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AIAudioMessage &&
      other.audioUrl == audioUrl &&
      other.duration == duration;
  }
}
