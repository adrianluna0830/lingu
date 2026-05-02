import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:lingu/domain/interfaces/stt/audio_encoding_enum.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/interfaces/stt/speech_result.dart';
import 'package:lingu/domain/interfaces/stt/word_detail.dart';

class ReplicateSttService implements ISpeechToTextService {
  final String apiToken;
  final String version = '1495a9cddc83b2203b0d8d3516e38b80fd1572ebc4bc5700ac1da56a9b3ed886';

  ReplicateSttService({required this.apiToken});

  @override
  Future<SpeechResult> recognize({
    required Uint8List audioBytes,
    bool enableAutomaticPunctuation = false,
    AudioEncodingEnum encoding = AudioEncodingEnum.linear16,
    int sampleRateHertz = 16000,
    String bcp47ToRecognize = 'en-US',
  }) async {
    final languageCode = bcp47ToRecognize.split('-')[0];
    
    // Convert to data URI
    final base64Audio = base64Encode(audioBytes);
    final dataUri = 'data:application/octet-stream;base64,$base64Audio';

    final url = Uri.parse('https://api.replicate.com/v1/predictions');
    final headers = {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
      'Prefer': 'wait',
    };

    final body = {
      'version': version,
      'input': {
        'file': dataUri,
        'language': languageCode,
        'group_segments': true,
      }
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Replicate API error: ${response.statusCode} ${response.body}');
    }

    final data = jsonDecode(response.body);
    return _mapToSpeechResult(data);
  }

  SpeechResult _mapToSpeechResult(Map<String, dynamic> data) {
    // If we used Prefer: wait, the output might be directly in 'output' or we might need to check status
    final status = data['status'];
    if (status == 'failed') {
      throw Exception('Replicate prediction failed: ${data['error']}');
    }

    final output = data['output'];
    if (output == null) {
      return const SpeechResult(transcript: '', confidence: 0.0);
    }

    final segments = output['segments'] as List<dynamic>? ?? [];
    final fullTranscript = segments.map((s) => s['text']).join(' ').trim();
    
    final words = <WordDetail>[];
    for (final segment in segments) {
      final segmentWords = segment['words'] as List<dynamic>? ?? [];
      for (final word in segmentWords) {
        words.add(WordDetail(
          word: word['word'] ?? '',
          confidence: 1.0, // Whisper diarization might not provide per-word confidence in this output schema
          startTime: Duration(milliseconds: ((word['start'] ?? 0.0) * 1000).round()),
          endTime: Duration(milliseconds: ((word['end'] ?? 0.0) * 1000).round()),
        ));
      }
    }

    return SpeechResult(
      transcript: fullTranscript,
      confidence: 1.0,
      words: words,
    );
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
