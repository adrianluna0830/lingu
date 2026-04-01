import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';

@module
abstract class ChatModule {
  @preResolve
  @Scope('chat')
  Future<IAIModel> getAIModel(IAPIFabric<IAIModel> fabric) => fabric.create();

  @preResolve
  @Scope('chat')
  Future<ITextToSpeechService> getTTS(IAPIFabric<ITextToSpeechService> fabric) => fabric.create();

  @preResolve
  @Scope('chat')
  Future<IPronunciationAssessment> getPronunciationAssessment(
    IAPIFabric<IPronunciationAssessment> fabric,
  ) =>
      fabric.create();

  @Scope('chat')
  ChatLanguages getChatLanguages(LocaleSettingsService service) {
    final native = service.nativeLocale.value;
    final target = service.learningLocale.value;
    if (native == null || target == null) {
      throw Exception("Chat languages not configured");
    }
    return ChatLanguages(native: native, target: target);
  }
}
