import 'dart:typed_data';
import 'package:lingu/domain/interfaces/stt/audio_encoding_enum.dart';
import 'package:lingu/domain/interfaces/stt/speech_result.dart';


abstract class ISpeechToTextService {
  Future<SpeechResult> recognize({
    required Uint8List audioBytes,
    bool enableAutomaticPunctuation = false,
    AudioEncodingEnum encoding = AudioEncodingEnum.linear16,
    int sampleRateHertz = 16000,
    String bcp47ToRecognize = 'en-US',
  });

  Future<double?> getCreditsUsage();
  Future<double?> getRemainingCreditsUsage();
}
