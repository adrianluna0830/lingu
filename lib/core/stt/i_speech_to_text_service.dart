import 'dart:typed_data';
import 'package:lingu/core/stt/audio_encoding.dart';
import 'package:lingu/core/stt/speech_result.dart';


abstract class ISpeechToTextService {
  Future<SpeechResult> recognize(
    Uint8List audioBytes, {
    required AudioEncoding encoding,
    required int sampleRateHertz,
    required String languageCode,
  });
}
