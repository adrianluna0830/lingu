import 'dart:typed_data';

import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';

abstract class ITextToSpeechService {
  Future<SynthesisResponse> synthesizeSpeechText({
    required String text,
    required LanguageLocale languageLocale,
    String? voiceName,
    double speakingRate = 1.0,
    bool isIPA = false,
  });
  Future<List<String>> getAvailableVoices({required String? code});

  Future<double?> getCreditsUsage();
  Future<double?> getRemainingCreditsUsage();
}
