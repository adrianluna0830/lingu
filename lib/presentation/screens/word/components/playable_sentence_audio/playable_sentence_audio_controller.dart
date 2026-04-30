import 'package:lingu/domain/audio/managers/audio_player_manager.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:signals_flutter/signals_flutter.dart';

class PlayableSentenceAudioController {
  late final AudioPlayerManager _audioPlayerManager = di<AudioPlayerManager>();
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
