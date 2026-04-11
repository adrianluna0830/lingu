import 'dart:typed_data';
import 'package:lingu/core/stt/audio_encoding_enum.dart';
import 'package:lingu/core/stt/speech_result.dart';


abstract class ISpeechToTextService {
  Future<SpeechResult> recognize({
    required Uint8List audioBytes,
    bool enableAutomaticPunctuation = false,
    AudioEncodingEnum encoding = AudioEncodingEnum.linear16,
    int sampleRateHertz = 16000,
    String bcp47ToRecognize = 'en-US',
  });
}
