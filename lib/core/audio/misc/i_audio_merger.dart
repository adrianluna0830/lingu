import 'dart:typed_data';

abstract class IAudioMerger {
  Future<Uint8List> merge(
    List<Uint8List> audioChunks, {
    int sampleRate = 16000,
    int bitDepth = 16,
    int channels = 1,
  });
}