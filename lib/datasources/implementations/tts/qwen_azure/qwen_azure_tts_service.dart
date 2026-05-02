import 'dart:convert' as convert;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/interfaces/tts/synthesis_with_timepoints_response.dart';
import 'package:lingu/domain/interfaces/tts/tts_exceptions.dart';

class QwenAzureTTSService implements ITextToSpeechService {
  final http.Client _httpClient;
  final String _replicateApiKey;
  final String _azureApiKey;
  final String _azureRegion;

  QwenAzureTTSService({
    required http.Client httpClient,
    required String replicateApiKey,
    required String azureApiKey,
    required String azureRegion,
  })  : _httpClient = httpClient,
        _replicateApiKey = replicateApiKey,
        _azureApiKey = azureApiKey,
        _azureRegion = azureRegion;

  @override
  Future<SynthesisResponse> synthesizeSpeechText({
    required String text,
    required LanguageLocale languageLocale,
    String? voiceName,
    double speakingRate = 1.0,
    bool isIPA = false,
  }) async {
    List<int> audioBytes;

    if (isIPA) {
      audioBytes = await _synthesizeWithAzure(text, languageLocale.bcp47, voiceName ?? 'en-US-AvaNeural');
    } else {
      audioBytes = await _synthesizeWithQwen(text, languageLocale.bcp47, voiceName ?? 'Serena');
    }

    return SynthesisResponse(
      audioBytes: Uint8List.fromList(audioBytes),
      duration: const Duration(seconds: 1),
      text: text,
      isIPA: isIPA,
    );
  }

  @override
  Future<List<String>> getAvailableVoices({required String? code}) async {
    return ['Serena', 'Aiden'];
  }

  Future<List<int>> _synthesizeWithAzure(String text, String languageCode, String voiceName) async {
    if (voiceName == 'Serena' || voiceName == 'Aiden') {
      voiceName = 'en-US-AvaNeural';
    }

    final ssml = '''
<speak version="1.0" xml:lang="$languageCode">
    <voice name="$voiceName">
        <phoneme alphabet="ipa" ph="$text">$text</phoneme>
    </voice>
</speak>
    ''';

    final uri = Uri.parse('https://$_azureRegion.tts.speech.microsoft.com/cognitiveservices/v1');
    final response = await _httpClient.post(
      uri,
      headers: {
        'Ocp-Apim-Subscription-Key': _azureApiKey,
        'Content-Type': 'application/ssml+xml',
        'X-Microsoft-OutputFormat': 'audio-16khz-128kbitrate-mono-mp3',
        'User-Agent': 'lingu',
      },
      body: ssml,
    );

    if (response.statusCode != 200) {
      throw TTSInvalidRequestException('Azure TTS error: ${response.statusCode} ${response.body}');
    }

    return response.bodyBytes;
  }

  Future<List<int>> _synthesizeWithQwen(String text, String languageCode, String voiceName) async {
    final uri = Uri.parse('https://api.replicate.com/v1/models/qwen/qwen3-tts/predictions');
    
    final bodyMap = {
      'input': {
        'mode': 'custom_voice',
        'text': text,
        'speaker': voiceName,
        'language': languageCode,
      }
    };

    final response = await _httpClient.post(
      uri,
      headers: {
        'Authorization': 'Bearer $_replicateApiKey',
        'Content-Type': 'application/json',
        'Prefer': 'wait',
      },
      body: convert.jsonEncode(bodyMap),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw TTSInvalidRequestException('Replicate Qwen TTS error: ${response.statusCode} ${response.body}');
    }

    final map = convert.jsonDecode(response.body) as Map<String, dynamic>;
    
    if (map['status'] == 'failed' || map['status'] == 'canceled') {
      throw TTSInvalidRequestException('Replicate prediction failed: ${map['error']}');
    }
    
    final output = map['output'];
    
    if (output == null) {
       final getUrl = map['urls']['get'];
       if (getUrl != null) {
           return await _pollReplicateResult(getUrl);
       }
       throw TTSInvalidRequestException('Replicate output is null and no get URL provided.');
    }

    return await _downloadOutput(output);
  }

  Future<List<int>> _pollReplicateResult(String getUrl) async {
    int attempts = 0;
    while (attempts < 30) {
      await Future.delayed(const Duration(seconds: 1));
      final response = await _httpClient.get(
        Uri.parse(getUrl),
        headers: {
          'Authorization': 'Bearer $_replicateApiKey',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final map = convert.jsonDecode(response.body) as Map<String, dynamic>;
        final status = map['status'];
        if (status == 'succeeded') {
          return await _downloadOutput(map['output']);
        } else if (status == 'failed' || status == 'canceled') {
          throw TTSInvalidRequestException('Replicate prediction failed: ${map['error']}');
        }
      }
      attempts++;
    }
    throw TTSInvalidRequestException('Replicate prediction timed out.');
  }

  Future<List<int>> _downloadOutput(dynamic output) async {
    if (output is String) {
      if (output.startsWith('data:')) {
        final commaIndex = output.indexOf(',');
        final base64Str = output.substring(commaIndex + 1);
        return convert.base64Decode(base64Str);
      } else if (output.startsWith('http')) {
        final audioRes = await _httpClient.get(Uri.parse(output));
        if (audioRes.statusCode == 200) {
          return audioRes.bodyBytes;
        }
        throw TTSInvalidRequestException('Failed to download audio from $output');
      }
    }
    throw TTSInvalidRequestException('Unexpected output format from Replicate: $output');
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
