import 'dart:async';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:signals/signals.dart';

enum AudioPlaybackState {
  playing,
  paused,
  stopped,
}


abstract class IAudioPlayerManager {
  ReadonlySignal<String?> get currentSource;
  ReadonlySignal<AudioPlaybackState> get playbackState;
  ReadonlySignal<Duration> get position;
  ReadonlySignal<Duration> get duration;
  Stream<void> get onCompletion;

  Future<void> playOrResume(String source);
  Future<void> playFromPosition(String source, Duration start, {bool autoPlay = true});
  Future<void> pause();
  Future<void> stop();
  Future<void> seek(Duration position);
  Future<Duration> getDuration(String source);
  Future<void> dispose();
}

extension AudioPlayerX on IAudioPlayerManager {
  bool isActive(String source) => currentSource.value == source;

  Future<void> toggle(String source) async {
    if (currentSource.value != source) {
      await playOrResume(source);
      return;
    }
    switch (playbackState.value) {
      case AudioPlaybackState.playing:
        await pause();
      case AudioPlaybackState.paused:
      case AudioPlaybackState.stopped:
        await playOrResume(source);
    }
  }
}
