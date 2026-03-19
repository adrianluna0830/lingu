import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
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
          children: [
            IconButton(
              onPressed: widget.controller.cancelRecording,
              icon: const Icon(Icons.cancel),
            ),
            IconButton(
              onPressed: widget.controller.stopRecording,
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
      ],
    );
  }
}
