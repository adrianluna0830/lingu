import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/i_audio_merger.dart';
import 'package:lingu/core/audio/i_audio_utils.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/features/chat/logic/message/messages_manager.dart';
import 'package:signals/signals.dart';

@injectable
class AudioInputHandler
{
  final MessagesManager _messagesManager;
  final IAudioRecorder _audioRecorder;
  final IAudioPlayerManager _audioPlayerManager;
  final IAudioPathSaver _audioPathSaver;
  final IAudioMerger _audioMerger;

  AudioInputHandler(this._messagesManager, this._audioRecorder, this._audioPlayerManager, this._audioPathSaver, this._audioMerger);

  
  Stream<Amplitude> get amplitudeStream => _audioRecorder.onAmplitudeChanged;

  final _speakingTargetLanguage = signal(true);
  ReadonlySignal get speakingTargetLanguage => _speakingTargetLanguage;
  final List<Uint8List> _audioChunks = [];

  Future<void> startRecording() async {
    _audioRecorder.start();
  }

  Future<void> sendRecording() async {
    final Uint8List audio = await _audioRecorder.stop();
    _audioChunks.add(audio);

    final mergedAudio = await _audioMerger.merge(_audioChunks);
    final filepath = await _audioPathSaver.saveToPath(mergedAudio, true);
    
    Duration duration = await _audioPlayerManager.getDuration(filepath);

    await _messagesManager.addAudioMessage(
      audioUrl: filepath,
      duration: duration, isUser: true,
    );

    _audioChunks.clear();
    _speakingTargetLanguage.value = true;
  }

  Future<void> toggleRecording() async {
    if (_audioRecorder.isRecording.value) {
      final Uint8List audio = await _audioRecorder.stop();
      _audioChunks.add(audio);
    } else {
      await _audioRecorder.start();
    }
  }



  Future<void> toggleLanguage() async {
    final Uint8List audio = await _audioRecorder.stop();
    _audioChunks.add(audio);
    _speakingTargetLanguage.value = !_speakingTargetLanguage.value;
    await _audioRecorder.start();
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.stop();
    _audioChunks.clear();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}
