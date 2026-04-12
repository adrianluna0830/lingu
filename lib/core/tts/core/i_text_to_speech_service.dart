import 'dart:typed_data';

import 'package:lingu/core/tts/core/synthesis_with_timepoints_response.dart';

abstract class ITextToSpeechService
{
  Future<Uint8List> synthesizeSpeechText({required String text, required String? voiceName, required String speechBcp47, required double speakingRate});
  Future<Uint8List> synthesizeSpeechSSML({required String ssml, required String? voiceName, required String speechBcp47, required double speakingRate});
  Future<List<String>> getAvailableVoices({required String? code});
  Future<SynthesisWithTimepointsResponse> synthesizeSpeechWithTimepoints({required String text, required String? voiceName, required String speechBcp47, required double speakingRate});
}
