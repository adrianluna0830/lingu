import 'package:flutter/material.dart';
import 'package:lingu/presentation/widgets/interactive_selectable_text.dart';
import 'package:lingu/presentation/screens/word/components/playable_sentence_audio/playable_sentence_audio_controller.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PlayableSentenceAudio extends StatefulWidget {
  final String audioPath;
  final String sentence;
  final VoidCallback onWordInfo;
  final VoidCallback onChat;

  const PlayableSentenceAudio({
    super.key,
    required this.audioPath,
    required this.sentence,
    required this.onWordInfo,
    required this.onChat,
  });

  @override
  State<PlayableSentenceAudio> createState() => _PlayableSentenceAudioState();
}

class _PlayableSentenceAudioState extends State<PlayableSentenceAudio> {
  late final PlayableSentenceAudioController _controller = PlayableSentenceAudioController(audioPath: widget.audioPath);
  @override
  Widget build(BuildContext context) {
    final isPlaying = _controller.isPlaying.watch(context);
    return Row(
      children: [
        InteractiveSelectableText(
          text: widget.sentence,
          // textStyle: TextStyle(fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal),
          onChat: widget.onChat,
          onWordInfo: widget.onWordInfo,
        ),
        IconButton(
          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
          onPressed: () {
            if (isPlaying) {
              _controller.stop();
            } else {
              _controller.play();
            }
          },
        ),
      ],
    );
  }
}
