import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lingu/features/home/ui/widgets/interactable_text.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/word/word.dart';

class WordViewController {
  void Function(String word)? onWordInfo;
  void Function(String sentence)? onChat;
}

class ImageAndCredits extends StatefulWidget {
  final WordImage image;
  final double? width;
  final double? height;
  const ImageAndCredits({
    super.key,
    required this.image,
    this.width,
    this.height,
  });

  @override
  State<ImageAndCredits> createState() => _ImageAndCreditsState();
}

class _ImageAndCreditsState extends State<ImageAndCredits> {
  final _showCredits = signal(false);

  @override
  Widget build(BuildContext context) {
    final showCredits = _showCredits.watch(context);
    return GestureDetector(
      onTap: () => _showCredits.value = !showCredits,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.image.width / widget.image.height,
            child: Image.file(
              File(widget.image.imagePath),
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
            ),
          ),
          if (showCredits)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.image.imageCredits,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}

class PageViewDirectionButtons extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const PageViewDirectionButtons({super.key, required this.totalPages, required this.currentPage, required this.onLeft, required this.onRight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onLeft,
        ),
        const Spacer(),
        Text('${currentPage + 1} / $totalPages'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: onRight,
        ),
      ],
    );
  }
}

class PlayableSentenceAudioController {
  late final IAudioPlayerManager _audioPlayerManager = di<IAudioPlayerManager>();
  final String audioPath;
  ReadonlySignal<bool> get isPlaying => _audioPlayerManager.getIsActiveSignal(audioPath);

  PlayableSentenceAudioController({required this.audioPath});

  void play() async {
    _audioPlayerManager.playFromPosition(audioPath, Duration.zero, autoPlay: true);
  }

  void stop() async {
    await _audioPlayerManager.stop(audioPath);
  }
}

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
        InteractableText(
          text: widget.sentence,
          textStyle: TextStyle(fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal),
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
