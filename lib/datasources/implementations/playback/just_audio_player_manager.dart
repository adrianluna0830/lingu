import 'dart:async';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:lingu/domain/interfaces/audio_playback/i_audio_playback.dart';
import 'package:signals/signals.dart';

class JustAudioPlayerManager extends IAudioPlayerManager {
  final ja.AudioPlayer _player = ja.AudioPlayer();

  final Signal<String?> _currentSource = signal(null);
  final Signal<AudioPlaybackState> _playbackState = signal(AudioPlaybackState.stopped);
  final Signal<Duration> _duration = signal(Duration.zero);
  final Signal<double> _playbackSpeed = signal(1.0);

  late final _playbackStateContainer =
      readonlySignalContainer<AudioPlaybackState, String>(
    (source) => computed(() => _currentSource.value == source
        ? _playbackState.value
        : AudioPlaybackState.stopped),
    cache: true,
  );

  late final _playbackSpeedContainer = readonlySignalContainer<double, String>(
    (source) => _playbackSpeed,
    cache: true,
  );

  bool _completed = false;

  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();

  final StreamController<String> _onCompletionController =
      StreamController<String>.broadcast();

  late final StreamSubscription _playerStateSubscription;
  late final StreamSubscription _positionSubscription;
  late final StreamSubscription _durationSubscription;

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
      _completed = false;
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
    double? speed,
  }) async {
    final effectiveSpeed = speed ?? _playbackSpeed.value;

    if (_currentSource.value != source) {
      _currentSource.value = source;
      await _player.setFilePath(source);
    } else if (_completed) {
      await _player.pause();
    }

    if (speed != null) {
      _playbackSpeed.value = speed;
    }
    await _player.setSpeed(effectiveSpeed);
    await _player.seek(start);

    if (autoPlay) {
      _playbackState.value = AudioPlaybackState.playing;
      await _player.play();
    }
  }

  @override
  Future<void> play(String source) async {
    if (_currentSource.value != source) {
      _currentSource.value = source;
      await _player.setFilePath(source);
    } else if (_completed) {
      await _player.pause();
      await _player.seek(Duration.zero);
    }
    await _player.play();
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
    _positionController.add(Duration.zero);
    _currentSource.value = null;
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
  ReadonlySignal<double> getPlaybackSpeedSignal(String source) {
    return _playbackSpeedContainer(source);
  }

  @override
  Stream<String> getOnCompletion(String source) {
    return _onCompletionController.stream.where((s) => s == source);
  }

  @override
  Stream<Duration> getPositionStream(String source) {
    return _positionController.stream.where((pos) {
      return _currentSource.value == source;
    });
  }

  @override
  Future<void> setSpeed(String source, double speed) async {
    _playbackSpeed.value = speed;
    if (_currentSource.value == source) {
      await _player.setSpeed(speed);
    }
  }

  @override
  Future<void> dispose() async {
    await _playerStateSubscription.cancel();
    await _positionSubscription.cancel();
    await _durationSubscription.cancel();
    await _positionController.close();
    await _onCompletionController.close();
    _playbackStateContainer.dispose();
    _playbackSpeedContainer.dispose();
    await _player.dispose();
  }
}