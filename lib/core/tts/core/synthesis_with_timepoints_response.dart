import 'dart:typed_data';


class SynthesisWithTimepoints {
  final Uint8List audioContent;
  final List<SynthesisTimepoint> timepoints;
  final Duration duration;
  String get sentence => timepoints.map((t) => t.word).join(' ');

  const SynthesisWithTimepoints({
    required this.audioContent,
    required this.timepoints,
    required this.duration,
  });
}

class SynthesisTimepoint {
  final String word;
  final Duration offset;
  final Duration duration;

  const SynthesisTimepoint({
    required this.word,
    required this.offset,
    required this.duration,
  });
}
