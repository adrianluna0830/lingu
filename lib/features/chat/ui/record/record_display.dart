import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:signals/signals_flutter.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

class LanguageAmplitude extends waveform.Amplitude {
  final bool isTarget;
  LanguageAmplitude({
    required super.current,
    required super.max,
    required this.isTarget,
  });
}

class RecordDisplay extends StatefulWidget {
  final RecordController controller;
  const RecordDisplay({super.key, required this.controller});

  @override
  State<RecordDisplay> createState() => _RecordDisplayState();
}

class _RecordDisplayState extends State<RecordDisplay> {
  late Stream<waveform.Amplitude> _waveformStream;

  @override
  void initState() {
    super.initState();
    _initStream();
    widget.controller.startRecording();
  }

  void _initStream() {
    _waveformStream = widget.controller.amplitudeStream.map(
      (amp) => LanguageAmplitude(
        current: amp.value,
        max: amp.maxValue,
        isTarget: widget.controller.speakingTargetLanguage.value,
      ),
    );
  }

  @override
  void didUpdateWidget(RecordDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _initStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTargetLanguage = widget.controller.speakingTargetLanguage.watch(context);
    final isPaused = widget.controller.isPaused.watch(context);

    return Column(
      children: [
        Expanded(
          child: waveform.AnimatedWaveList(
            stream: _waveformStream,
            barBuilder: (animation, amplitude) {
              final isTarget = (amplitude is LanguageAmplitude)
                  ? amplitude.isTarget
                  : true;
              return waveform.WaveFormBar(
                animation: animation,
                amplitude: amplitude,
                color: isTarget ? Colors.red : Colors.blue,
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: widget.controller.cancelRecording,
              icon: const Icon(Icons.cancel),
            ),
            IconButton(
              onPressed: widget.controller.toggleRecording,
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            ),
            IconButton(
              onPressed: widget.controller.toggleLanguage,
              icon: Icon(
                isTargetLanguage ? Icons.language : Icons.translate,
              ),
            ),
            IconButton(
              onPressed: widget.controller.stopRecording,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}