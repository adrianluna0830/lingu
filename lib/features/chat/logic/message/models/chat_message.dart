
sealed class ChatMessage {
  final int id;
  const ChatMessage({required this.id});
}

extension ChatMessageX on ChatMessage {
  bool get isUser => this is UserTextMessage || this is UserAudioMessage;
}

class UserTextMessage extends ChatMessage {
  final String text;

  const UserTextMessage({
    required super.id,
    required this.text,
  });

  UserTextMessage copyWith({
    int? id,
    String? text,
  }) {
    return UserTextMessage(
      id: id ?? this.id,
      text: text ?? this.text,
    );
  }
}

class UserSpeechAudio {
  final String filePath;
  final bool isTargetLanguage;

  const UserSpeechAudio({
    required this.filePath,
    required this.isTargetLanguage,
  });
}

class UserAudioMessage extends ChatMessage {
  final String fullMergedAudioFilePath;
  final List<UserSpeechAudio> individualAudioFilePaths;
  final Duration duration;

  const UserAudioMessage({
    required super.id,
    required this.fullMergedAudioFilePath,
    required this.individualAudioFilePaths,
    required this.duration,
  });

  UserAudioMessage copyWith({
    int? id,
    String? fullMergedAudioUrl,
    List<UserSpeechAudio>? individualAudioUrls,
    Duration? duration,
  }) {
    return UserAudioMessage(
      id: id ?? this.id,
      fullMergedAudioFilePath: fullMergedAudioUrl ?? this.fullMergedAudioFilePath,
      individualAudioFilePaths: individualAudioUrls ?? this.individualAudioFilePaths,
      duration: duration ?? this.duration,
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
