import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/misc/i_audio_merger.dart';

@Singleton(as: IAudioMerger)
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