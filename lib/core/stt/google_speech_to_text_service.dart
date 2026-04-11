import 'dart:typed_data';
import 'package:googleapis/speech/v1.dart';
import 'package:lingu/core/stt/audio_encoding_enum.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/core/stt/speech_result.dart';
import 'package:lingu/core/stt/word_detail.dart';

class GoogleSpeechToTextService implements ISpeechToTextService {
  final SpeechApi _speechApi;

  GoogleSpeechToTextService(this._speechApi);

  @override
  Future<SpeechResult> recognize({
    required Uint8List audioBytes,
    bool enableAutomaticPunctuation = false,
    AudioEncodingEnum encoding = AudioEncodingEnum.linear16,
    int sampleRateHertz = 16000,
    String bcp47ToRecognize = 'en-US',
  }) async {
    final audio = RecognitionAudio();
    audio.contentAsBytes = audioBytes;

    final request = RecognizeRequest(
      config: RecognitionConfig(
        encoding: encoding.value,
        sampleRateHertz: sampleRateHertz,
        enableAutomaticPunctuation: enableAutomaticPunctuation,
        languageCode: bcp47ToRecognize,
        enableWordConfidence: true,
        enableWordTimeOffsets: true,
      ),
      audio: audio,
    );

    final response = await _speechApi.speech.recognize(request);

    return _mapToSpeechResult(response);
  }

  SpeechResult _mapToSpeechResult(RecognizeResponse response) {
    final bestAlternative =
        response.results?.firstOrNull?.alternatives?.firstOrNull;

    if (bestAlternative == null) {
      return const SpeechResult(transcript: '', confidence: 0.0);
    }

    final words =
        bestAlternative.words
            ?.map(
              (w) => WordDetail(
                word: w.word ?? '',
                confidence: w.confidence ?? 0.0,
                startTime: _parseDuration(w.startTime),
                endTime: _parseDuration(w.endTime),
              ),
            )
            .toList() ??
        [];

    return SpeechResult(
      transcript: bestAlternative.transcript ?? '',
      confidence: bestAlternative.confidence ?? 0.0,
      words: words,
    );
  }

  Duration? _parseDuration(String? raw) {
    if (raw == null) return null;
    final seconds = double.tryParse(raw.replaceAll('s', ''));
    if (seconds == null) return null;
    return Duration(microseconds: (seconds * 1e6).round());
  }
}
