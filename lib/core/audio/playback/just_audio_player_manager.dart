import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:signals/signals.dart';
@Singleton(as: IAudioPlayerManager)
class JustAudioPlayerManager extends IAudioPlayerManager {
  final ja.AudioPlayer _player = ja.AudioPlayer();

  final Signal<String?> _currentSource = signal(null);
  final Signal<AudioPlaybackState> _playbackState = signal(AudioPlaybackState.stopped);
  final Signal<Duration> _position = signal(Duration.zero);
  final Signal<Duration> _duration = signal(Duration.zero);

  final StreamController<void> _onCompletionController =
      StreamController<void>.broadcast();

  late final StreamSubscription _playerStateSubscription;
  late final StreamSubscription _positionSubscription;
  late final StreamSubscription _durationSubscription;

  JustAudioPlayerManager() {
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ja.ProcessingState.completed) {
        _playbackState.value = AudioPlaybackState.stopped;
        _currentSource.value = null;
        _position.value = Duration.zero;
        _onCompletionController.add(null);
        return;
      }
      if (state.playing) {
        _playbackState.value = AudioPlaybackState.playing;
      } else {
        _playbackState.value =
            state.processingState == ja.ProcessingState.idle
                ? AudioPlaybackState.stopped
                : AudioPlaybackState.paused;
      }
    });

    _positionSubscription = _player.positionStream.listen((pos) {
      _position.value = pos;
    });

    _durationSubscription = _player.durationStream.listen((dur) {
      _duration.value = dur ?? Duration.zero;
    });
  }

  @override
  ReadonlySignal<String?> get currentSource => _currentSource;

  @override
  ReadonlySignal<AudioPlaybackState> get playbackState => _playbackState;

  @override
  ReadonlySignal<Duration> get position => _position;

  @override
  ReadonlySignal<Duration> get duration => _duration;

  @override
  Stream<void> get onCompletion => _onCompletionController.stream;

  @override
  Future<void> playOrResume(String source) async {
    if (_currentSource.value == source &&
        _playbackState.value == AudioPlaybackState.paused) {
      await _player.play();
      return;
    }

    _currentSource.value = source;
    await _player.setUrl(source);
    await _player.play();
  }

  @override
  Future<void> playFromPosition(
    String source,
    Duration start, {
    bool autoPlay = true,
  }) async {
    if (_currentSource.value != source) {
      _currentSource.value = source;
      await _player.setUrl(source);
    }

    await _player.seek(start);

    if (autoPlay) {
      await _player.play();
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    _currentSource.value = null;
    _position.value = Duration.zero;
    _playbackState.value = AudioPlaybackState.stopped;
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<Duration> getDuration(String source) async {
    if (_currentSource.value == source && _duration.value != Duration.zero) {
      return _duration.value;
    }

    final tempPlayer = ja.AudioPlayer();
    try {
      final duration = await tempPlayer.setUrl(source);
      return duration ?? Duration.zero;
    } finally {
      await tempPlayer.dispose();
    }
  }

  @override
  Future<void> dispose() async {
    await _playerStateSubscription.cancel();
    await _positionSubscription.cancel();
    await _durationSubscription.cancel();
    await _onCompletionController.close();
    await _player.dispose();
  }
}