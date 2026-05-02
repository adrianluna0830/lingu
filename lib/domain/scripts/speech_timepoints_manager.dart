import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/interfaces/stt/audio_encoding_enum.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:lingu/domain/interfaces/tts/tts_exceptions.dart';

class SpeechTimepointsManager {
  final ITextToSpeechService _ttsService;
  final ISpeechToTextService _sttService;

  SpeechTimepointsManager({
    required ITextToSpeechService ttsService,
    required ISpeechToTextService sttService,
  })  : _ttsService = ttsService,
        _sttService = sttService;

  Future<SynthesisWithTimepoints> execute({
    required String text,
    required LanguageLocale languageLocale,
    String? voiceName,
    double speakingRate = 1.0,
  }) async {
    final ttsResponse = await _ttsService.synthesizeSpeechText(
      text: text,
      languageLocale: languageLocale,
      voiceName: voiceName,
      speakingRate: speakingRate,
      isIPA: false,
    );

    final speechResult = await _sttService.recognize(
      audioBytes: ttsResponse.audioBytes,
      enableAutomaticPunctuation: false,
      encoding: AudioEncodingEnum.mp3,
      sampleRateHertz: 24000,
      bcp47ToRecognize: languageLocale.bcp47,
    );

    final timepoints = speechResult.words
        .where((w) => w.startTime != null && w.endTime != null)
        .map((w) => SynthesisTimepoint(
              word: w.word,
              offset: w.startTime!,
              duration: Duration(
                microseconds:
                    w.endTime!.inMicroseconds - w.startTime!.inMicroseconds,
              ),
            ))
        .toList();

    if (timepoints.isEmpty) {
      throw TTSUnknownException(
          'STT did not return word timing information');
    }

    return SynthesisWithTimepoints(
      audioBytes: ttsResponse.audioBytes,
      duration: ttsResponse.duration,
      text: text,
      timepoints: timepoints,
    );
  }
}
