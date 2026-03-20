import 'dart:io';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';
import 'package:path_provider/path_provider.dart';

@singleton
class AudioMessageInput {
  final ChatMessagesManager _messagesManager;
  final IAudioRecorder _audioRecorder;
  final IAudioPlayerManager _audioPlayerManager;
  AudioMessageInput(this._messagesManager, this._audioRecorder, this._audioPlayerManager);

  Stream<Amplitude> get amplitudeStream => _audioRecorder.onAmplitudeChanged;
  Function()? notifyStopRecording;
  Function()? notifyCancelRecording;
  Future<void> startRecording() async {
    _audioRecorder.start();
  }

  Future<void> stopRecording() async {
    notifyStopRecording?.call();

    final filepath  = await _audioRecorder.stopAndGetFilePath(); 


    Duration duration = await _audioPlayerManager.getDuration(filepath);

    _messagesManager.addAudioMessage(audioUrl: filepath, isUser: true, duration: duration);

  }

  Future<void> cancelRecording() async {
    notifyCancelRecording?.call();
    await _audioRecorder.stop();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}
