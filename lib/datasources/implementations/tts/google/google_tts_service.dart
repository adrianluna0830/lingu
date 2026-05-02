import 'dart:convert' as convert;
import 'package:googleapis/texttospeech/v1.dart';
import 'package:http/http.dart' as http;
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:lingu/domain/interfaces/tts/tts_exceptions.dart';
import 'package:lingu/datasources/implementations/tts/google/google_tts_exception_mapper.dart';

class GoogleTTSService implements ITextToSpeechService {
  final TexttospeechApi _api;
  final http.Client _httpClient;
  final String _apiKey;

  GoogleTTSService({
    required TexttospeechApi api,
    required http.Client httpClient,
    required String apiKey,
  }) : _api = api,
       _httpClient = httpClient,
       _apiKey = apiKey;

  @override
  Future<SynthesisResponse> synthesizeSpeechText({
    required String text,
    required LanguageLocale languageLocale,
    String? voiceName,
    double speakingRate = 1.0,
    bool isIPA = false,
  }) async {
    try {
      final String ssml = isIPA
          ? '<speak><phoneme alphabet="ipa" ph="$text">$text</phoneme></speak>'
          : (text.trim().startsWith('<speak>') ? text : _buildSsmlWithMarks(text));

      final bodyMap = {
        'input': {'ssml': ssml},
        'voice': {
          'languageCode': languageLocale.bcp47,
          'name': voiceName,
        },
        'audioConfig': {'audioEncoding': 'MP3', 'speakingRate': speakingRate},
      };

      final body = convert.jsonEncode(bodyMap);

      final response = await _httpClient.post(
        Uri.parse(
          'https://texttospeech.googleapis.com/v1beta1/text:synthesize',
        ),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode != 200) {
        throw switch (response.statusCode) {
          401 || 403 => const TTSAuthException(),
          429 => const TTSRateLimitException(),
          400 => TTSInvalidRequestException('Bad request: ${response.body}'),
          _ => TTSUnknownException('TTS error ${response.statusCode}'),
        };
      }

      final map = convert.jsonDecode(response.body) as Map<String, dynamic>;
      final audioBytes = convert.base64.decode(map['audioContent'] as String);

      return SynthesisResponse(
        audioBytes: audioBytes,
        duration: const Duration(seconds: 1),
        text: text,
        isIPA: isIPA,
      );
    } on TTSException {
      rethrow;
    } catch (e) {
      throw GoogleTTSExceptionMapper.map(e);
    }
  }

  @override
  Future<List<String>> getAvailableVoices({required String? code}) async {
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

  String _buildSsmlWithMarks(String text) {
    final words = text.trim().split(RegExp(r'\s+'));
    final buffer = StringBuffer('<speak>');
    for (var i = 0; i < words.length; i++) {
      final escapedWord = _escapeXml(words[i]);

      buffer.write('<mark name="${i}_$escapedWord"/>');
      buffer.write(escapedWord);
      if (i < words.length - 1) buffer.write(' ');
    }
    buffer.write('<mark name="END"/>');
    buffer.write('</speak>');
    return buffer.toString();
  }

  String _escapeXml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }

  @override
  Future<double?> getCreditsUsage() async {
    throw UnimplementedError();
  }

  @override
  Future<double?> getRemainingCreditsUsage() async {
    throw UnimplementedError();
  }
}
