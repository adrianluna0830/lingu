import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:lingu/core/pronunciation/models/pronunciation_assessment_errors.dart';
import 'package:lingu/core/pronunciation/models/raw_pronunciation_assessment_response.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';


class LinuxPronunciationAssessmentService implements IPronunciationAssessmentService {
  Process? _process;
  bool _isEvaluating = false;
  StreamSubscription<String>? _stdoutSub;
  StreamSubscription<String>? _stderrSub;
  Completer<String>? _responseCompleter;

  LinuxPronunciationAssessmentService._();

  static Future<LinuxPronunciationAssessmentService> create({
    required String speechKey,
    required String speechEndpoint,
    String binaryPath = 'lib/core/pronunciation/service/linux/python/pc_pronunciation/dist/main',
  }) async {
    final service = LinuxPronunciationAssessmentService._();
    await service._init(speechKey, speechEndpoint, binaryPath);
    return service;
  }

  Future<void> _init(String key, String endpoint, String binaryPath) async {
    try {
      _process = await Process.start(
        binaryPath,
        [],
        environment: {
          'SPEECH_KEY': key,
          'SPEECH_ENDPOINT': endpoint,
        },
      );

      _stdoutSub = _process!.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (_responseCompleter != null && !_responseCompleter!.isCompleted) {
          _responseCompleter!.complete(line);
        }
      });

      _stderrSub = _process!.stderr
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) => debugPrint('[PronunciationService stderr] $line'));

    } catch (e) {
      throw ServiceCreationError('failed to start python binary: $e');
    }
  }

  @override
  Future<RawPronunciationAssessmentResponse> assessFromWavAsync(
    {required Uint8List wavBytes,
    required String language,
    int sampleRate = 16000,
    int bitsPerSample = 16,
    int channels = 1,
    String referenceText = '',
    String gradingSystem = 'HundredMark',
    String granularity = 'Phoneme',
    String phonemeAlphabet = 'IPA',
    int nBestPhonemeCount = 5,
    bool enableMiscue = false,
    bool enableProsodyAssessment = false,
    Duration timeout = const Duration(seconds: 180),
  }) async {
    if (_process == null) {
      throw const ServiceNotInitializedError();
    }
    if (_isEvaluating) {
      throw const EvaluationInProgressError();
    }

    _isEvaluating = true;
    _responseCompleter = Completer<String>();

    try {
      final requestPayload = {
        'audio_base64': base64Encode(wavBytes),
        'language': language,
        'sample_rate': sampleRate,
        'bits_per_sample': bitsPerSample,
        'channels': channels,
        'reference_text': referenceText,
        'grading_system': gradingSystem,
        'granularity': granularity,
        'phoneme_alphabet': phonemeAlphabet,
        'n_best_phoneme_count': nBestPhonemeCount,
        'enable_miscue': enableMiscue,
        'enable_prosody_assessment': enableProsodyAssessment,
      };

      _process!.stdin.writeln(jsonEncode(requestPayload));
      await _process!.stdin.flush();

      final responseString = await _responseCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          throw AssessmentTimeoutError('assessment exceeded the time limit of ${timeout.inSeconds} seconds');
        },
      );

      final responseJson = jsonDecode(responseString);
      if (responseJson['success'] == true) {
        return RawPronunciationAssessmentResponse.fromMap(responseJson['data']);
      } else {
        final errorCode = responseJson['error_code'] as String?;
        final message = (responseJson['message'] ?? responseJson['error']) as String? ?? 'unknown error in python script';

        switch (errorCode) {
          case 'AUTH_ERROR':
            throw AuthenticationError(message);
          case 'NO_SPEECH':
            throw const NoSpeechError();
          case 'NETWORK_ERROR':
            throw NetworkError(message);
          case 'QUOTA_ERROR':
            throw QuotaExceededError(message);
          case 'INTERNAL_ERROR':
            throw InternalServiceError(message);
          default:
            throw AssessmentError(message);
        }
      }
    } on FormatException catch (e) {
      throw AssessmentError('failed to decode response: $e');
    } finally {
      _isEvaluating = false;
      _responseCompleter = null;
    }
  }

  @override
  Future<void> dispose() async {
    _process?.kill();
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    _process = null;
  }
}