import 'dart:typed_data';

import 'package:lingu/domain/pronunciation/models/pronunciation_assessment_result.dart';

abstract class IPronunciationAssessmentService {

  Future<PronunciationAssessmentResult> assessFromWavAsync(
    { required Uint8List wavBytes,
    required String language,
    int sampleRate = 16000,
    int bitsPerSample = 16,
    int channels = 1,
    String referenceText = '',
    String gradingSystem = 'HundredMark',
    String granularity = 'Phoneme',
    String phonemeAlphabet = 'IPA',
    int nBestPhonemeCount = 1,
    bool enableMiscue = false,
    bool enableProsodyAssessment = false,
    Duration timeout = const Duration(seconds: 30),
  });

  Future<void> dispose();

  Future<double?> getCreditsUsage();
  Future<double?> getRemainingCreditsUsage();
}