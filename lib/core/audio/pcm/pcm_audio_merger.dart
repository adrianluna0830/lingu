import 'dart:typed_data';

import 'package:lingu/core/audio/misc/i_audio_merger.dart';

class PCMAudioMerger implements IAudioMerger {
  @override
  Future<Uint8List> merge(
    List<Uint8List> audioChunks, {
    int sampleRate = 16000,
    int bitDepth = 16,
    int channels = 1,
  }) async {
    final merged = audioChunks.fold<List<int>>(
      [],
      (acc, chunk) => acc..addAll(chunk),
    );
    return Uint8List.fromList(merged);
  }
}