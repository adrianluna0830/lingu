import 'dart:async';
import 'package:signals/signals.dart';

enum AudioPlaybackState {
  playing,
  paused,
  stopped,
}

abstract class IAudioPlayerManager {
  ReadonlySignal<AudioPlaybackState> getPlaybackStateSignal(String source);
  ReadonlySignal<bool> getIsActiveSignal(String source);
  Stream<Duration> getPositionStream(String source);
  Stream<void> getOnCompletion(String source);
  Future<void> playFromPosition(String source, Duration start, {bool autoPlay = true});
  Future<void> pause(String source);
  Future<void> stop(String source);
  Future<Duration> getDuration(String source);
  Future<void> dispose();
}