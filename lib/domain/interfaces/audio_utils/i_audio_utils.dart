import 'dart:typed_data';

abstract class IAudioUtils {
  Future<Uint8List> cut(Uint8List audioData, Duration offset, Duration duration);
  
  Future<Uint8List> merge(
    List<Uint8List> audioChunks, {
    int sampleRate = 16000,
    int bitDepth = 16,
    int channels = 1,
  });

  Future<String> saveToPath(Uint8List audioData, bool temporary);

  Future<Uint8List> retrieve(String filePath);
}
