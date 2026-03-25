import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:signals/signals_flutter.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

class RecordDisplay extends StatefulWidget {
  final RecordController controller;
  const RecordDisplay({super.key, required this.controller});

  @override
  State<RecordDisplay> createState() => _RecordDisplayState();
}

class _RecordDisplayState extends State<RecordDisplay> {
  @override
  void initState() {
    super.initState();
    widget.controller.startRecording();
  }

  @override
  Widget build(BuildContext context) {
    final isTargetLanguage = widget.controller.speakingTargetLanguage.watch(context);
    final isPaused = widget.controller.isPaused.watch(context);

    return Column(
      children: [
        Expanded(
          child: waveform.AnimatedWaveList(
            stream: widget.controller.amplitudeStream.map(
              (amp) =>
                  waveform.Amplitude(current: amp.value, max: amp.maxValue),
            ),
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