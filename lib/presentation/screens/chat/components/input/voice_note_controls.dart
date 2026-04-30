import 'package:flutter/material.dart';
import 'package:lingu/presentation/screens/chat/components/input/voice_note_controller.dart';
import 'package:signals/signals_flutter.dart';

class VoiceNoteControls extends StatefulWidget {
  final String audioUrl;
  final Duration duration;
  const VoiceNoteControls({super.key  , required this.audioUrl, required this.duration});

  @override
  State<VoiceNoteControls> createState() => _VoiceNoteControlsState();
}

class _VoiceNoteControlsState extends State<VoiceNoteControls> {
  late final VoiceNoteInternalController _internalController = VoiceNoteInternalController();

  @override
  void initState() {
    super.initState();
    _internalController.init(
      widget.audioUrl,
      widget.duration,
    );
  }

  @override
  void dispose() {
    _internalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = widget.duration.inMilliseconds.toDouble();
    final currentMs = _internalController.currentPosition
        .watch(context)
        .inMilliseconds.clamp(0, maxMs).toDouble();
    final isPlaying = _internalController.isPlaying.watch(context);
    final canToggle = _internalController.canTogglePlay.watch(context);


    return GestureDetector(
      onLongPress: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: canToggle ? () => _internalController.togglePlayStatus() : null,
          ),
          Flexible(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.0,
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              ),
              child: Slider(
                value: currentMs,
                max: maxMs,
                onChangeStart: (v) {
                  _internalController.onSeekStart();
                },
                onChanged: (v) => _internalController.onSeekChanged(
                  Duration(milliseconds: v.toInt()),
                ),
                onChangeEnd: (v) {
                  _internalController.onSeekEnd(Duration(milliseconds: v.toInt()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}