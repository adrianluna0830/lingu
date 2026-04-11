import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';

class ChatModule {
  Future<IAIService> getAIModel(IAIFabric fabric) => fabric.create();

  Future<ISpeechToTextService> getSTT(ISTTFabric fabric) => fabric.create();

  Future<ITextToSpeechService> getTTS(ITTSFabric fabric) => fabric.create();

  Future<IPronunciationAssessmentService> getPronunciationAssessment(
    IPronunciationAssessmentFabric fabric,
  ) =>
      fabric.create();

  ChatLanguages getChatLanguages(LocaleSettingsService service) {
    final native = service.nativeLocale.value;
    final target = service.learningLocale.value;
    if (native == null || target == null) {
      throw Exception("Chat languages not configured");
    }
    return ChatLanguages(native: native, target: target);
  }
}
