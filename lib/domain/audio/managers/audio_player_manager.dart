import 'dart:async';
import 'package:lingu/domain/audio/managers/sound_manager.dart';
import 'package:lingu/domain/interfaces/audio_playback/i_audio_playback.dart';
import 'package:signals/signals.dart';

class AudioPlayerManager {
  final SoundManager _soundManager;
  final IAudioPlayerManager _audioPlayer;
  String? _activeSource;
  late final void Function() _speedCleanup;

  AudioPlayerManager(this._soundManager, this._audioPlayer) {
    _speedCleanup = effect(() {
      final speed = _soundManager.speedSignal.value.value;
      if (_activeSource != null) {
        _audioPlayer.setSpeed(_activeSource!, speed);
      }
    });
  }

  Future<void> play(String source) async {
    _activeSource = source;
    await _audioPlayer.setSpeed(source, _soundManager.speedSignal.value.value);
    await _audioPlayer.play(source);
  }

  Future<void> pause(String source) async {
    await _audioPlayer.pause(source);
  }

  Future<void> stop(String source) async {
    if (_activeSource == source) _activeSource = null;
    await _audioPlayer.stop(source);
  }

  Future<void> setSpeed(String source, double speed) async {
    await _audioPlayer.setSpeed(source, speed);
  }

  Future<void> playFromPosition(String source, Duration start, {bool autoPlay = true, double? speed}) async {
    _activeSource = source;
    final effectiveSpeed = speed ?? _soundManager.speedSignal.value.value;
    await _audioPlayer.playFromPosition(source, start, autoPlay: autoPlay, speed: effectiveSpeed);
  }

  Future<Duration> getDuration(String source) async {
    return await _audioPlayer.getDuration(source);
  }

  ReadonlySignal<AudioPlaybackState> getPlaybackStateSignal(String source) {
    return _audioPlayer.getPlaybackStateSignal(source);
  }

  ReadonlySignal<bool> getIsActiveSignal(String source) {
    return _audioPlayer.getIsActiveSignal(source);
  }

  ReadonlySignal<double> getPlaybackSpeedSignal(String source) {
    return _audioPlayer.getPlaybackSpeedSignal(source);
  }

  Stream<Duration> getPositionStream(String source) {
    return _audioPlayer.getPositionStream(source);
  }

  Stream<void> getOnCompletion(String source) {
    return _audioPlayer.getOnCompletion(source);
  }

  Future<void> dispose() async {
    _speedCleanup();
    await _audioPlayer.dispose();
  }
}
