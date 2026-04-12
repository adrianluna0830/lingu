import 'dart:typed_data';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:signals/signals.dart';

class AudioInputHandler {
  final ChatMessagesManager _messagesManager;
  final IAudioRecorder _audioRecorder;
  final IAudioPlayerManager _audioPlayerManager;
  final IAudioUtils _audioUtils;

  AudioInputHandler(
      this._messagesManager,
      this._audioRecorder,
      this._audioPlayerManager,
      this._audioUtils);

  Stream<Amplitude> get amplitudeStream => _audioRecorder.onAmplitudeChanged;

  final _speakingTargetLanguage = signal(true);
  ReadonlySignal get speakingTargetLanguage => _speakingTargetLanguage;
  final List<UserSpeechAudio> _audioChunks = [];

  Future<void> startRecording() async {
    _audioRecorder.start();
  }

  Future<void> _saveCurrentChunk() async {
    final Uint8List audio = await _audioRecorder.stop();
    final path = await _audioUtils.saveToPath(audio, true);
    _audioChunks.add(UserSpeechAudio(
        filePath: path, isTargetLanguage: _speakingTargetLanguage.value));
  }

  Future<void> sendRecording() async {
    if (_audioRecorder.isRecording.value) {
      await _saveCurrentChunk();
    }

    if (_audioChunks.isEmpty) return;

    final List<Uint8List> pcmChunks = [];
    for (final chunk in _audioChunks) {
      final bytes = await _audioUtils.retrieve(chunk.filePath);
      pcmChunks.add(bytes);
    }

    final mergedAudio = await _audioUtils.merge(pcmChunks);
    final filepath = await _audioUtils.saveToPath(mergedAudio, true);

    Duration duration = await _audioPlayerManager.getDuration(filepath);

    _messagesManager.addUserAudioMessage(
      audioUrl: filepath,
      duration: duration,
      individualAudioUrls: List.from(_audioChunks),
    );

    _audioChunks.clear();
    _speakingTargetLanguage.value = true;
  }

  Future<void> toggleRecording() async {
    if (_audioRecorder.isRecording.value) {
      await _saveCurrentChunk();
    } else {
      await _audioRecorder.start();
    }
  }

  Future<void> toggleLanguage() async {
    if (_audioRecorder.isRecording.value) {
      await _saveCurrentChunk();
    }
    _speakingTargetLanguage.value = !_speakingTargetLanguage.value;
    await _audioRecorder.start();
  }

  Future<void> cancelRecording() async {
    if (_audioRecorder.isRecording.value) {
      await _audioRecorder.stop();
    }
    _audioChunks.clear();
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}
