import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note_controller.dart';
import 'package:signals/signals_flutter.dart';

class VoiceNote extends StatefulWidget {
  final String audioUrl;
  final Duration duration;
  const VoiceNote({super.key, required this.audioUrl, required this.duration});

  @override
  State<VoiceNote> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {
  final VoiceNoteController controller = VoiceNoteController();

  @override
  void initState() {
    super.initState();
    controller.init(
      widget.audioUrl,
      widget.duration,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = widget.duration.inMilliseconds.toDouble();
    final currentMs = controller.currentPosition
        .watch(context)
        .inMilliseconds.clamp(0, maxMs).toDouble();
    final isPlaying = controller.isPlaying.watch(context);
    final canToggle = controller.canTogglePlay.watch(context);


    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: canToggle ? () => controller.togglePlayStatus() : null,
        ),
        Flexible(
          child: Slider(
            value: currentMs,
            max: maxMs,
            onChangeStart: (v) {
              controller.onSeekStart();
            },
            onChanged: (v) => controller.onSeekChanged(
              Duration(milliseconds: v.toInt()),
            ),
            onChangeEnd: (v) {
              controller.onSeekEnd(Duration(milliseconds: v.toInt()));
            },
          ),
        ),
      ],
    );
  }
}