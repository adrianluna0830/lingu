import 'dart:typed_data';

class SynthesisResponse {
  final Uint8List audioBytes;
  final Duration duration;
  final String text;
  final bool isIPA;

  SynthesisResponse({
    required this.audioBytes,
    required this.duration,
    required this.text,
    this.isIPA = false,
  });
}

class SynthesisTimepoint {
  final String word;
  final Duration offset;
  final Duration duration;

  SynthesisTimepoint({
    required this.word,
    required this.offset,
    required this.duration,
  });
}

class SynthesisWithTimepoints extends SynthesisResponse {
  final List<SynthesisTimepoint> timepoints;

  SynthesisWithTimepoints({
    required super.audioBytes,
    required super.duration,
    required super.text,
    super.isIPA,
    required this.timepoints,
  });
}
