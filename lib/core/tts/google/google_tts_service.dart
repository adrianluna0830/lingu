import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:http/http.dart' as http;
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/tts/core/synthesis_with_timepoints_response.dart';
import 'package:lingu/core/tts/core/tts_exceptions.dart';
import 'package:lingu/core/tts/google/google_tts_exception_mapper.dart';

class GoogleTTSService implements ITextToSpeechService {
  final TexttospeechApi _api;
  final http.Client _httpClient;
  final String _apiKey;

  GoogleTTSService({
    required TexttospeechApi api,
    required http.Client httpClient,
    required String apiKey,
  })  : _api = api,
        _httpClient = httpClient,
        _apiKey = apiKey;

  @override
  Future<Uint8List> synthesizeSpeechText(
    String text,
    String? voiceName,
    String speechBcp47, {
    double speakingRate = 1.0,
  }) async {
    try {
      final response = await _api.text.synthesize(
        SynthesizeSpeechRequest(
          input: SynthesisInput(text: text),
          voice: VoiceSelectionParams(
            name: voiceName,
            languageCode: speechBcp47,
          ),
          audioConfig: AudioConfig(
            audioEncoding: 'MP3',
            speakingRate: speakingRate,
          ),
        ),
      );
      final audioContent = response.audioContent;
      if (audioContent == null) {
        throw const TTSInvalidRequestException('No audio content returned');
      }
      return convert.base64.decode(audioContent);
    } on TTSException {
      rethrow;
    } catch (e) {
      throw GoogleTTSExceptionMapper.map(e);
    }
  }

  @override
  Future<Uint8List> synthesizeSpeechSSML(
    String ssml,
    String? voiceName,
    String speechBcp47, {
    double speakingRate = 1.0,
  }) async {
    try {
      final response = await _api.text.synthesize(
        SynthesizeSpeechRequest(
          input: SynthesisInput(ssml: ssml),
          voice: VoiceSelectionParams(
            name: voiceName,
            languageCode: speechBcp47,
          ),
          audioConfig: AudioConfig(
            audioEncoding: 'MP3',
            speakingRate: speakingRate,
          ),
        ),
      );
      final audioContent = response.audioContent;
      if (audioContent == null) {
        throw const TTSInvalidRequestException('No audio content returned');
      }
      return convert.base64.decode(audioContent);
    } on TTSException {
      rethrow;
    } catch (e) {
      throw GoogleTTSExceptionMapper.map(e);
    }
  }

  @override
  Future<List<String>> getAvailableVoices(String? code) async {
    try {
      final response = await _api.voices.list(languageCode: code);
      return (response.voices ?? [])
          .map((v) => v.name ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } on TTSException {
      rethrow;
    } catch (e) {
      throw GoogleTTSExceptionMapper.map(e);
    }
  }

  @override
  Future<SynthesisWithTimepointsResponse> synthesizeSpeechWithTimepoints(
    String text,
    String? voiceName,
    String speechBcp47, {
    double speakingRate = 1.0,
  }) async {
    try {
      final ssml = _buildSsmlWithMarks(text);

      final body = convert.jsonEncode({
        'input': {'ssml': ssml},
        'voice': {
          'languageCode': speechBcp47,
          'name': voiceName,
        },
        'audioConfig': {
          'audioEncoding': 'MP3',
          'speakingRate': speakingRate,
        },
        'enableTimePointing': ['SSML_MARK'],
      });

      final response = await _httpClient.post(
        Uri.parse(
          'https://texttospeech.googleapis.com/v1/text:synthesize?key=$_apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw switch (response.statusCode) {
          401 || 403 => const TTSAuthException(),
          429        => const TTSRateLimitException(),
          400        => TTSInvalidRequestException('Bad request: ${response.body}'),
          _          => TTSUnknownException('TTS error ${response.statusCode}'),
        };
      }

      final map = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final audioBytes = convert.base64.decode(map['audioContent'] as String);
      final rawTimepoints = (map['timepoints'] as List<dynamic>? ?? []);

      final parsed = rawTimepoints.map((t) {
        final m = t as Map<String, dynamic>;
        final parts = (m['markName'] as String).split('_');
        return (
          word: parts.sublist(1).join('_'),
          timeSeconds: (m['timeSeconds'] as num).toDouble(),
        );
      }).toList();

      final timepoints = List.generate(parsed.length, (i) {
        final offset = Duration(
          microseconds: (parsed[i].timeSeconds * 1e6).round(),
        );
        final nextSeconds = i + 1 < parsed.length
            ? parsed[i + 1].timeSeconds
            : parsed[i].timeSeconds;
        final duration = Duration(
          microseconds: ((nextSeconds - parsed[i].timeSeconds) * 1e6).round(),
        );
        return SynthesisTimepoint(
          word: parsed[i].word,
          offset: offset,
          duration: duration,
        );
      });

      return SynthesisWithTimepointsResponse(
        audioContent: audioBytes,
        timepoints: timepoints,
      );
    } on TTSException {
      rethrow;
    } catch (e) {
      throw GoogleTTSExceptionMapper.map(e);
    }
  }

  String _buildSsmlWithMarks(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    final buffer = StringBuffer('<speak>');
    for (var i = 0; i < words.length; i++) {
      buffer.write('<mark name="${i}_${words[i]}"/>');
      buffer.write(words[i]);
      if (i < words.length - 1) buffer.write(' ');
    }
    buffer.write('</speak>');
    return buffer.toString();
  }
}