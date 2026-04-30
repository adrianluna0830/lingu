import 'package:flutter/material.dart';
import 'package:lingu/presentation/widgets/selectable_words.dart';
import 'package:lingu/domain/audio/managers/audio_player_manager.dart';
import 'package:lingu/domain/interfaces/audio_playback/i_audio_playback.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:signals/signals_flutter.dart';

class AIAudioMessageDetailsInternalController {
  SpeechAudio data;
  final AudioPlayerManager _audioPlayerManager;
  final _currentWordIndex = signal<int?>(null);
  ReadonlySignal<int?> get currentWordIndex => _currentWordIndex;

  AIAudioMessageDetailsInternalController(this.data, this._audioPlayerManager) {
    _audioPlayerManager.getPositionStream(data.audioUrl).listen((position) {
      final state =
          _audioPlayerManager.getPlaybackStateSignal(data.audioUrl).value;
      if (state != AudioPlaybackState.playing) {
        return;
      }

      final timepoints = data.timepoints;
      if (timepoints.isEmpty) return;

      for (int i = 0; i < timepoints.length; i++) {
        if (position < timepoints[i].offset) {
          _currentWordIndex.value = i == 0 ? 0 : i - 1;
          return;
        }
      }
      _currentWordIndex.value = timepoints.length - 1;
    });

    _audioPlayerManager.getOnCompletion(data.audioUrl).listen((_) {
      _currentWordIndex.value = null;
      _audioPlayerManager.stop(data.audioUrl);
    });
  }

  void changeWord(int index) {
    _currentWordIndex.value = index;
    final timepoint = data.timepoints[index];
    _audioPlayerManager.playFromPosition(
      data.audioUrl,
      timepoint.offset,
      autoPlay: true,
    );
  }
}

class AIAudioMessageDetails extends StatefulWidget {
  final SpeechAudio data;
  const AIAudioMessageDetails({super.key, required this.data});

  @override
  State<AIAudioMessageDetails> createState() => _AIAudioMessageDetailsState();
}

class _AIAudioMessageDetailsState extends State<AIAudioMessageDetails> {
  late AIAudioMessageDetailsInternalController _controller;

  @override
  void initState() {
    super.initState();
    _controller = di<AIAudioMessageDetailsInternalController>(
      param1: widget.data,
    );
  }

  @override
  void didUpdateWidget(AIAudioMessageDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      _controller.data = widget.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    final timepoints = widget.data.timepoints;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Watch((context) {
              final currentIndex = _controller.currentWordIndex.value;
              return SelectableWords(
                words: timepoints.map((t) => t.word).toList(),
                activeIndex: currentIndex,
                onTap: (_, index) => _controller.changeWord(index),
              );
            }),
          ),
        ),
      ],
    );
  }
}
