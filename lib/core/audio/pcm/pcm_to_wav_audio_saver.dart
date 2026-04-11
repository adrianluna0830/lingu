import 'dart:io';
import 'dart:typed_data';

import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:path_provider/path_provider.dart';

class PCMToWavAudioSaver implements IAudioPathSaver {
  @override
  Future<String> saveToPath(
    Uint8List audioData,
    bool temporary,
  ) async {
    final dir = temporary
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();

    final fileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.wav';
    final path = '${dir.path}/$fileName';

    final wavData = await pcmToWav(audioData, 16000, 1);

    await File(path).writeAsBytes(wavData);
    return path;
  }

  Future<Uint8List> pcmToWav(
    Uint8List pcmData,
    int sampleRate,
    int numChannels, {
    int bitDepth = 16,
  }) async {
    final dataSize = pcmData.length;
    final header = ByteData(44);

    header.setUint32(0, 0x52494646, Endian.big);        // "RIFF"
    header.setUint32(4, 36 + dataSize, Endian.little);  // file size - 8
    header.setUint32(8, 0x57415645, Endian.big);        // "WAVE"

    header.setUint32(12, 0x666d7420, Endian.big);       // "fmt "
    header.setUint32(16, 16, Endian.little);            // chunk size
    header.setUint16(20, 1, Endian.little);             // PCM = 1
    header.setUint16(22, numChannels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(                                   // byte rate
      28,
      sampleRate * numChannels * bitDepth ~/ 8,
      Endian.little,
    );
    header.setUint16(                                   // block align
      32,
      numChannels * bitDepth ~/ 8,
      Endian.little,
    );
    header.setUint16(34, bitDepth, Endian.little);

    header.setUint32(36, 0x64617461, Endian.big);       // "data"
    header.setUint32(40, dataSize, Endian.little);

    return Uint8List.fromList([
      ...header.buffer.asUint8List(),
      ...pcmData,
    ]);
  }
}