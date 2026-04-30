import 'dart:typed_data';

import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';

abstract class ITextToSpeechService {
  Future<SynthesisResponse> synthesizeSpeechText({
    required String text,
    required String languageCode,
    String? voiceName,
    double speakingRate = 1.0,
    bool isIPA = false,
  });
  Future<List<String>> getAvailableVoices({required String? code});
  Future<SynthesisWithTimepoints> synthesizeSpeechWithTimepoints({
    required String text,
    required String languageCode,
    String? voiceName,
    double speakingRate = 1.0,
    bool isIPA = false,
  });

  Future<double?> getCreditsUsage();
  Future<double?> getRemainingCreditsUsage();
}
