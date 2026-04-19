import 'dart:io';
import 'dart:typed_data';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:path_provider/path_provider.dart';

class PCMAudioUtils implements IAudioUtils {
  final int sampleRate;
  final int bitDepth;
  final int channels;

  PCMAudioUtils({
    this.sampleRate = 16000,
    this.bitDepth = 16,
    this.channels = 1,
  });

  @override
  Future<Uint8List> cut(Uint8List audioData, Duration offset, Duration duration) async {
    assert(audioData.isNotEmpty, 'Audio data cannot be empty');
    
    if (audioData.isEmpty) {
      throw Exception('Provided audio data is empty or invalid.');
    }

    final int bytesPerSample = bitDepth ~/ 8;
    final int bytesPerSecond = sampleRate * channels * bytesPerSample;
    final int blockAlign = channels * bytesPerSample;
    
    int startByte = (offset.inMicroseconds * bytesPerSecond) ~/ 1000000;
    int lengthInBytes = (duration.inMicroseconds * bytesPerSecond) ~/ 1000000;
    
    startByte = startByte - (startByte % blockAlign);
    lengthInBytes = lengthInBytes - (lengthInBytes % blockAlign);

    if (startByte < 0 || startByte >= audioData.length) {
      throw Exception('Invalid offset: The calculated start position ($startByte) is out of bounds for audio length (${audioData.length}).');
    }
    
    if (audioData.length >= 44 && 
        audioData[0] == 0x52 && audioData[1] == 0x49 && 
        audioData[2] == 0x46 && audioData[3] == 0x46) {
      startByte += 44;
      if (startByte + lengthInBytes > audioData.length) {
        lengthInBytes = audioData.length - startByte;
        lengthInBytes = lengthInBytes - (lengthInBytes % blockAlign);
      }
    } else {
      if (startByte + lengthInBytes > audioData.length) {
        lengthInBytes = audioData.length - startByte;
        lengthInBytes = lengthInBytes - (lengthInBytes % blockAlign);
      }
    }
    
    if (lengthInBytes <= 0) {
      throw Exception('Invalid duration: The calculated cut length results in an empty audio array.');
    }

    return audioData.sublist(startByte, startByte + lengthInBytes);
  }

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

  @override
  Future<String> saveToPath(Uint8List audioData, bool temporary) async {
    final dir = temporary
        ? await getTemporaryDirectory()
        : await getApplicationDocumentsDirectory();

    final fileName = 'audio_${DateTime.now().microsecondsSinceEpoch}_${audioData.hashCode}.wav';
    final path = '${dir.path}/$fileName';

    final wavData = await _pcmToWav(audioData, 16000, 1);

    await File(path).writeAsBytes(wavData);
    return path;
  }

  Future<Uint8List> _pcmToWav(
    Uint8List pcmData,
    int sampleRate,
    int numChannels, {
    int bitDepth = 16,
  }) async {
    final dataSize = pcmData.length;
    final header = ByteData(44);

    header.setUint32(0, 0x52494646, Endian.big);        
    header.setUint32(4, 36 + dataSize, Endian.little);  
    header.setUint32(8, 0x57415645, Endian.big);        

    header.setUint32(12, 0x666d7420, Endian.big);       
    header.setUint32(16, 16, Endian.little);            
    header.setUint16(20, 1, Endian.little);             
    header.setUint16(22, numChannels, Endian.little);
    header.setUint32(24, sampleRate, Endian.little);
    header.setUint32(                                   
      28,
      sampleRate * numChannels * bitDepth ~/ 8,
      Endian.little,
    );
    header.setUint16(                                   
      32,
      numChannels * bitDepth ~/ 8,
      Endian.little,
    );
    header.setUint16(34, bitDepth, Endian.little);

    header.setUint32(36, 0x64617461, Endian.big);       
    header.setUint32(40, dataSize, Endian.little);

    return Uint8List.fromList([
      ...header.buffer.asUint8List(),
      ...pcmData,
    ]);
  }

  @override
  Future<Uint8List> retrieve(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('Audio file not found at path: $filePath');
    }

    final bytes = await file.readAsBytes();

    if (bytes.length > 44) {
      return bytes.sublist(44);
    }
    
    return bytes;
  }
}
