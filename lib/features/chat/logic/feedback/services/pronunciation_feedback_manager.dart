import 'dart:io';
import 'dart:typed_data';

import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/stt/audio_encoding_enum.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback_result.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';

@Scope('chat')
@lazySingleton
class PronunciationFeedbackManager {
  final IPronunciationAssessmentService _assessmentService;
  final IAIService _aiModel;
  final ISpeechToTextService _sttService;
  final ChatLanguages _languages;
  PronunciationFeedbackManager(
    this._assessmentService,
    this._aiModel,
    this._sttService,
    this._languages,
  );

  Future<PronunciationFeedbackResult> analyze(
    List<UserSpeechAudio> audioFiles,
  ) async {
    String combinedTranscript = '';
    for (var audio in audioFiles) {
      final file = File(audio.filePath);
      final bytes = await file.readAsBytes();
      // final res = await _sttService.recognize(
      //   audioBytes: bytes,
      //   encoding: AudioEncodingEnum.linear16,
      //   sampleRateHertz: 16000,
      //   bcp47ToRecognize: audio.isTargetLanguage
      //       ? _languages.target.bcp47
      //       : _languages.native.bcp47,
      // );
      // final transcript = res.transcript;
      final transcript = " ";
      if (audio.isTargetLanguage) {
        final rawResponse = await _assessmentService.assessFromWavAsync(
          wavBytes: bytes,
          language: _languages.target.bcp47,
        );
        print(rawResponse.toJson());
      }
      combinedTranscript += ' ${transcript.trim()}';
    }
    print(combinedTranscript);
    return PronunciationFeedbackResult(
      originalTranscript: combinedTranscript.trim(),
    );
  }
}
