import 'package:flutter/material.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/word/word_view_widgets.dart';

class AIAudioMessageDetailsInternalController {
  AIAudioMessageDetailsViewDto data;
  final IAudioPlayerManager _audioPlayerManager;
  final _currentWordIndex = signal<int?>(null);
  ReadonlySignal<int?> get currentWordIndex => _currentWordIndex;

  ReadonlySignal<double> get playbackSpeed =>
      _audioPlayerManager.getPlaybackSpeedSignal(data.audioUrl);

  bool _wasPlayingBeforeSlider = false;

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

  void changeSpeed(double speed) {
    _audioPlayerManager.setSpeed(data.audioUrl, speed);
  }

  void onSpeedSliderStart() {
    final state =
        _audioPlayerManager.getPlaybackStateSignal(data.audioUrl).value;
    _wasPlayingBeforeSlider = state == AudioPlaybackState.playing;
    if (_wasPlayingBeforeSlider) {
      _audioPlayerManager.pause(data.audioUrl);
    }
  }

  void onSpeedSliderEnd() {
    if (_wasPlayingBeforeSlider) {
      _audioPlayerManager.play(data.audioUrl);
      _wasPlayingBeforeSlider = false;
    }
  }
}

class AIAudioMessageDetails extends StatefulWidget {
  final AIAudioMessageDetailsViewDto data;
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
    final theme = Theme.of(context);
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
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Watch((context) {
                final speed = _controller.playbackSpeed.value;
                return Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: speed,
                        min: 0.6,
                        max: 1.0,
                        onChanged: _controller.changeSpeed,
                        onChangeStart: (_) => _controller.onSpeedSliderStart(),
                        onChangeEnd: (_) => _controller.onSpeedSliderEnd(),
                      ),
                    ),
                    Text(
                      'x${speed.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ],
    );
  }
}
