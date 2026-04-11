import 'dart:async';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:signals/signals.dart';

class JustAudioPlayerManager extends IAudioPlayerManager {
  final ja.AudioPlayer _player = ja.AudioPlayer();

  final Signal<String?> _currentSource = signal(null);
  final Signal<AudioPlaybackState> _playbackState = signal(AudioPlaybackState.stopped);
  final Signal<Duration> _duration = signal(Duration.zero);

  bool _completed = false;

  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();

  final StreamController<String> _onCompletionController =
      StreamController<String>.broadcast();

  late final StreamSubscription _playerStateSubscription;
  late final StreamSubscription _positionSubscription;
  late final StreamSubscription _durationSubscription;

  late final _playbackStateContainer =
      readonlySignalContainer<AudioPlaybackState, String>(
    (source) => computed(() => _currentSource.value == source
        ? _playbackState.value
        : AudioPlaybackState.stopped),
    cache: true,
  );

  JustAudioPlayerManager() {
    _playerStateSubscription = _player.playerStateStream.listen(_onPlayerState);
    _positionSubscription = _player.positionStream.listen((pos) {
      _positionController.add(pos);
    });
    _durationSubscription = _player.durationStream.listen(
      (dur) => _duration.value = dur ?? Duration.zero,
    );
  }

  void _onPlayerState(ja.PlayerState state) {
    if (state.processingState == ja.ProcessingState.completed) {
      if (_completed) {
        return;
      }
      _completed = true;
      _playbackState.value = AudioPlaybackState.stopped;
      _positionController.add(Duration.zero);
      final source = _currentSource.value;
      if (source != null) _onCompletionController.add(source);
      return;
    }

    if (_completed) {
      return;
    }

    final newState = state.playing
        ? AudioPlaybackState.playing
        : state.processingState == ja.ProcessingState.idle
            ? AudioPlaybackState.stopped
            : AudioPlaybackState.paused;

    _playbackState.value = newState;
  }

  @override
  Future<void> playFromPosition(
    String source,
    Duration start, {
    bool autoPlay = true,
  }) async {
    if (_currentSource.value != source) {
      _currentSource.value = source;
      await _player.setFilePath(source);
    } else if (_completed) {
      await _player.pause();
      await _player.setFilePath(source);
    }

    _completed = false;
    await _player.seek(start);

    if (autoPlay) {
      _playbackState.value = AudioPlaybackState.playing;
      await _player.play();
    }
  }

  @override
  Future<void> pause(String source) async {
    if (_currentSource.value == source) {
      await _player.pause();
    }
  }

  @override
  Future<void> stop(String source) async {
    if (_currentSource.value != source) {
      return;
    }
    await _player.stop();
    _currentSource.value = null;
    _positionController.add(Duration.zero);
    _playbackState.value = AudioPlaybackState.stopped;
  }

  @override
  Future<Duration> getDuration(String source) async {
    if (_currentSource.value == source && _duration.value != Duration.zero) {
      return _duration.value;
    }
    return _fetchDuration(source);
  }

  Future<Duration> _fetchDuration(String source) async {
    final tempPlayer = ja.AudioPlayer();
    try {
      await tempPlayer.setFilePath(source);
      return tempPlayer.duration ?? Duration.zero;
    } finally {
      await tempPlayer.dispose();
    }
  }

  @override
  ReadonlySignal<bool> getIsActiveSignal(String source) {
    return computed(() => getPlaybackStateSignal(source).value != AudioPlaybackState.stopped);
  }

  @override
  ReadonlySignal<AudioPlaybackState> getPlaybackStateSignal(String source) {
    return _playbackStateContainer(source);
  }

  @override
  Stream<String> getOnCompletion(String source) {
    return _onCompletionController.stream.where((s) => s == source);
  }

  @override
  Stream<Duration> getPositionStream(String source) {
    return _positionController.stream.where((pos) {
      return _currentSource.value == source &&
          _playbackState.value == AudioPlaybackState.playing;
    });
  }

  @override
  Future<void> dispose() async {
    await _playerStateSubscription.cancel();
    await _positionSubscription.cancel();
    await _durationSubscription.cancel();
    await _positionController.close();
    await _onCompletionController.close();
    _playbackStateContainer.dispose();
    await _player.dispose();
  }
}