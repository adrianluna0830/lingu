import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';

@singleton
class AudioMessageInput {
  final ChatMessagesManager _messagesManager;
  final IAudioRecorder _audioRecorder = di<IAudioRecorder>();

  AudioMessageInput(this._messagesManager);

  Stream<Amplitude> get amplitudeStream => _audioRecorder.onAmplitudeChanged;
  Function()? notifyStopRecording;
  Function()? notifyCancelRecording;
  Future<void> startRecording() async {
    _audioRecorder.start();
  }

  Future<void> stopRecording() async {
    Uint8List audioData = await _audioRecorder.stop(); 
    notifyStopRecording?.call();

  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
    notifyCancelRecording?.call();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}
