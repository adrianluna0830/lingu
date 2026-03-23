import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

@Singleton(scope: 'chat')
class AudioMessageInput {
  final ChatMessagesManager _messagesManager;
  final IAudioRecorder _audioRecorder;
  final IAudioPlayerManager _audioPlayerManager;

  AudioMessageInput(this._messagesManager, this._audioRecorder, this._audioPlayerManager);

  Stream<Amplitude> get amplitudeStream => _audioRecorder.onAmplitudeChanged;

  Future<void> startRecording() async {
    _audioRecorder.start();
  }

  Future<void> stopRecording() async {
    final Uint8List audio = await _audioRecorder.stop();
    final dir = await getTemporaryDirectory();
    final filepath = path.join(dir.path, 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a');
    final file = File(filepath);
    await file.writeAsBytes(audio);
    Duration duration = await _audioPlayerManager.getDuration(filepath);
    _messagesManager.addAudioMessage(audioUrl: filepath, duration: duration);
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}