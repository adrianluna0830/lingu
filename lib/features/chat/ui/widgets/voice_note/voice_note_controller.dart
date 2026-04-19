import 'dart:async';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:signals/signals_flutter.dart';


class VoiceNoteInternalController {
  final IAudioPlayerManager _audioPlayerManager;

  VoiceNoteInternalController({
    IAudioPlayerManager? audioPlayerManager,
  }) : _audioPlayerManager = audioPlayerManager ?? di<IAudioPlayerManager>();

  late final String _audioUrl;
  late final Duration _duration;
  late final ReadonlySignal<AudioPlaybackState> _playbackState;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _completionSub;

  late final ReadonlySignal<bool> isPlaying;

  final _currentPosition = signal(Duration.zero);
  ReadonlySignal<Duration> get currentPosition => _currentPosition;

  final _canTogglePlay = signal(true);
  ReadonlySignal<bool> get canTogglePlay => _canTogglePlay;

  bool _isSeeking = false;
  bool _wasPlayingBeforeSeek = false;
  bool _hasCompleted = false;

  void init(String audioUrl, Duration duration) {
    _audioUrl = audioUrl;
    _duration = duration;
    _playbackState = _audioPlayerManager.getPlaybackStateSignal(_audioUrl);
    isPlaying = computed(() => _playbackState.value == AudioPlaybackState.playing);

    _positionSub = _audioPlayerManager
        .getPositionStream(_audioUrl)
        .listen((pos) {
          if (_isSeeking) return;
          
          if (_hasCompleted && pos < _duration - const Duration(milliseconds: 500)) {
            _hasCompleted = false;
          }

          _currentPosition.value = pos;

          // just_audio/media_kit may not always emit ProcessingState.completed
          // when the AudioMessage duration and the player's internal duration
          // are slightly different. We detect this by comparing position with
          // the known duration and simulate completion manually.
          if (!_hasCompleted && pos >= _duration) {
            _handleCompletion();
          }
        });

    _completionSub = _audioPlayerManager
        .getOnCompletion(_audioUrl)
        .listen((_) {
          if (_hasCompleted) return;
          _handleCompletion();
        });
  }

  void _handleCompletion() {
    _hasCompleted = true;
    _currentPosition.value = Duration.zero;
    // Explicitly pause so _playbackState moves to paused/stopped
    // in cases where just_audio did not emit ProcessingState.completed on its own
    // (duration mismatch between the message and the internal player state).
    _audioPlayerManager.pause(_audioUrl);
  }

  void togglePlayStatus() {
    if (!_canTogglePlay.value) return;

    if (_playbackState.value == AudioPlaybackState.playing) {
      _audioPlayerManager.pause(_audioUrl);
    } else {
      _hasCompleted = false;
      _audioPlayerManager.playFromPosition(_audioUrl, _currentPosition.value);
    }
  }

  void onSeekStart() {
    _isSeeking = true;
    _canTogglePlay.value = false;

    _wasPlayingBeforeSeek =
        !_hasCompleted && _playbackState.value == AudioPlaybackState.playing;

    if (_wasPlayingBeforeSeek) _audioPlayerManager.pause(_audioUrl);
  }

  void onSeekChanged(Duration position) => _currentPosition.value = position;

  void onSeekEnd(Duration position) {
    _isSeeking = false;
    _canTogglePlay.value = true;

    if (position >= _duration) {
      _hasCompleted = true;
      _currentPosition.value = Duration.zero;
      _audioPlayerManager.playFromPosition(_audioUrl, _duration, autoPlay: false);
      return;
    }

    _currentPosition.value = position;
    _audioPlayerManager.playFromPosition(
      _audioUrl,
      position,
      autoPlay: _wasPlayingBeforeSeek,
    );
  }

  void dispose() {
    _positionSub.cancel();
    _completionSub.cancel();
  }
}