import 'dart:typed_data';

import 'package:lingu/core/tts/core/synthesis_with_timepoints_response.dart';

abstract class ITextToSpeechService
{
  Future<Uint8List> synthesizeSpeechText(String text, String voiceName, String speechBcp47, {double speakingRate = 1.0});
  Future<Uint8List> synthesizeSpeechSSML(String ssml, String voiceName, String speechBcp47, {double speakingRate = 1.0});
  Future<List<String>> getAvailableVoices(String? code);
  Future<SynthesisWithTimepointsResponse> synthesizeSpeechWithTimepoints(String text, String voiceName, String speechBcp47, {double speakingRate = 1.0});
}
