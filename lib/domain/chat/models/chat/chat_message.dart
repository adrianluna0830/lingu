import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';

sealed class ChatMessageModel {
  final int id;
  const ChatMessageModel({required this.id});
}

extension ChatMessageModelX on ChatMessageModel {
  bool get isUser => this is UserTextMessageModel || this is UserAudioMessageModel;
}

class UserTextMessageModel extends ChatMessageModel {
  final String text;
  final List<UserTextInput> individualTextInputs;

  const UserTextMessageModel({
    required super.id,
    required this.text,
    required this.individualTextInputs,
  });

  UserTextMessageModel copyWith({
    int? id,
    String? text,
    List<UserTextInput>? individualTextInputs,
  }) {
    return UserTextMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      individualTextInputs: individualTextInputs ?? this.individualTextInputs,
    );
  }
}

abstract interface class UserLanguageSegment {
  bool get isTargetLanguage;
}

class UserTextInput implements UserLanguageSegment {
  final String text;
  @override
  final bool isTargetLanguage;

  UserTextInput(this.text, this.isTargetLanguage);
}

class UserSpeechAudio implements UserLanguageSegment {
  final String filePath;
  @override
  final bool isTargetLanguage;

  const UserSpeechAudio({
    required this.filePath,
    required this.isTargetLanguage,
  });
}

class UserAudioMessageModel extends ChatMessageModel {
  final String fullMergedAudioFilePath;
  final List<UserSpeechAudio> individualAudioFilePaths;
  final Duration duration;

  const UserAudioMessageModel({
    required super.id,
    required this.fullMergedAudioFilePath,
    required this.individualAudioFilePaths,
    required this.duration,
  });

  UserAudioMessageModel copyWith({
    int? id,
    String? fullMergedAudioUrl,
    List<UserSpeechAudio>? individualAudioUrls,
    Duration? duration,
  }) {
    return UserAudioMessageModel(
      id: id ?? this.id,
      fullMergedAudioFilePath:
          fullMergedAudioUrl ?? fullMergedAudioFilePath,
      individualAudioFilePaths:
          individualAudioUrls ?? individualAudioFilePaths,
      duration: duration ?? this.duration,
    );
  }
}

class AITextMessageModel extends ChatMessageModel {
  final String text;
  final String? translation;

  const AITextMessageModel({
    required super.id,
    required this.text,
    this.translation,
  });

  AITextMessageModel copyWith({int? id, String? text, String? translation}) {
    return AITextMessageModel(
      id: id ?? this.id,
      text: text ?? this.text,
      translation: translation ?? this.translation,
    );
  }
}

class AIAudioMessageModel extends ChatMessageModel {
  final String transcript;
  final String audioUrl;
  final Duration duration;
  final List<SynthesisTimepoint> timepoints;
  final String? translation;

  const AIAudioMessageModel({
    required super.id,
    required this.transcript,
    required this.audioUrl,
    required this.duration,
    required this.timepoints,
    this.translation,
  });

  AIAudioMessageModel copyWith({
    int? id,
    String? transcript,
    String? audioUrl,
    Duration? duration,
    List<SynthesisTimepoint>? timepoints,
    String? translation,
  }) {
    return AIAudioMessageModel(
      id: id ?? this.id,
      transcript: transcript ?? this.transcript,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      timepoints: timepoints ?? this.timepoints,
      translation: translation ?? this.translation,
    );
  }
}
