import 'dart:typed_data';

abstract class IAudioPathSaver {
  Future<String> saveToPath(Uint8List audioData, bool temporary);
}