import 'dart:typed_data';


class SynthesisTimepointAudioUrl {
  final List<SynthesisTimepoint> timepoints;
  final String audioUrl;

  SynthesisTimepointAudioUrl(this.timepoints, this.audioUrl);
}


class SynthesisWithTimepointsResponse {
  final Uint8List audioContent;
  final List<SynthesisTimepoint> timepoints;

  const SynthesisWithTimepointsResponse({
    required this.audioContent,
    required this.timepoints,
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
