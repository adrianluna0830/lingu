import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/ai/gemini/gemini_fabric.dart';
import 'package:lingu/core/pronunciation/pronunciation_assessment_fabric.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/tts/google/google_tts_fabric.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/core/stt/google_speech_to_text_fabric.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';

@module
abstract class ChatModule {
  @preResolve
  @Scope('chat')
  @singleton
  Future<IAIService> getAIModel(GeminiFabric fabric) => fabric.create();

  @preResolve
  @Scope('chat')
  @lazySingleton
  Future<ISpeechToTextService> getSTT(GoogleSpeechToTextFabric fabric) => fabric.create();

  @preResolve
  @Scope('chat')
  @singleton
  Future<ITextToSpeechService> getTTS(GoogleTTSFabric fabric) => fabric.create();

  @preResolve
  @Scope('chat')
  @singleton
  Future<IPronunciationAssessmentService> getPronunciationAssessment(
    PronunciationAssessmentFabric fabric,
  ) =>
      fabric.create();

  @Scope('chat')
  @singleton
  ChatLanguages getChatLanguages(LocaleSettingsService service) {
    final native = service.nativeLocale.value;
    final target = service.learningLocale.value;
    if (native == null || target == null) {
      throw Exception("Chat languages not configured");
    }
    return ChatLanguages(native: native, target: target);
  }
}
