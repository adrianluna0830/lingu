import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingu/presentation/widgets/selectable_words.dart';
import 'package:lingu/domain/audio/managers/audio_player_manager.dart';
import 'package:lingu/domain/interfaces/audio_playback/i_audio_playback.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:signals/signals_flutter.dart';

class SpeechTranscriptionWidget extends StatefulWidget {
  final SpeechAudio speechAudio;
  final bool highlightCurrentSentence;

  const SpeechTranscriptionWidget({
    super.key,
    required this.speechAudio,
    this.highlightCurrentSentence = false,
  });

  @override
  State<SpeechTranscriptionWidget> createState() => _SpeechTranscriptionWidgetState();
}

class _SpeechTranscriptionWidgetState extends State<SpeechTranscriptionWidget> {
  late final AudioPlayerManager _audioPlayerManager;
  final _currentWordIndex = signal<int?>(null);

  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<void>? _completionSubscription;

  @override
  void initState() {
    super.initState();
    _audioPlayerManager = di<AudioPlayerManager>();
    _setupListeners();
  }

  @override
  void didUpdateWidget(SpeechTranscriptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.speechAudio.audioUrl != oldWidget.speechAudio.audioUrl) {
      _cleanupListeners();
      _setupListeners();
    }
  }

  @override
  void dispose() {
    _cleanupListeners();
    super.dispose();
  }

  void _setupListeners() {
    final audioUrl = widget.speechAudio.audioUrl;

    _positionSubscription = _audioPlayerManager.getPositionStream(audioUrl).listen((position) {
      final state = _audioPlayerManager.getPlaybackStateSignal(audioUrl).value;
      if (state != AudioPlaybackState.playing) {
        _currentWordIndex.value = null;
        return;
      }

      final timepoints = widget.speechAudio.timepoints;
      if (timepoints.isEmpty) return;

      for (int i = 0; i < timepoints.length; i++) {
        if (position < timepoints[i].offset) {
          _currentWordIndex.value = i == 0 ? 0 : i - 1;
          return;
        }
      }
      _currentWordIndex.value = timepoints.length - 1;
    });

    _completionSubscription = _audioPlayerManager.getOnCompletion(audioUrl).listen((_) {
      _currentWordIndex.value = null;
      _audioPlayerManager.stop(audioUrl);
    });
  }

  void _cleanupListeners() {
    _positionSubscription?.cancel();
    _completionSubscription?.cancel();
    _positionSubscription = null;
    _completionSubscription = null;
  }

  void _onWordTap(String word, int index) {
    _currentWordIndex.value = index;
    final timepoint = widget.speechAudio.timepoints[index];
    _audioPlayerManager.playFromPosition(
      widget.speechAudio.audioUrl,
      timepoint.offset,
      autoPlay: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final timepoints = widget.speechAudio.timepoints;
    final words = timepoints.map((t) => t.word).toList();

    if (words.isEmpty) {
      return const SizedBox.shrink();
    }

    return Watch((context) {
      final currentIndex = _currentWordIndex.value;
      return SelectableWords(
        words: words,
        activeIndex: currentIndex,
        highlightSentence: widget.highlightCurrentSentence,
        onTap: _onWordTap,
      );
    });
  }
}
