import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/ai/core/i_ai_model_fabric.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/tts/core/i_tts_fabric.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';

@module
abstract class ChatModule {
  @Scope('chat')
  IAIModel getAIModel(IAIModelFabric fabric) => fabric.create();

  @Scope('chat')
  ITextToSpeechService getTTS(ITTSFabric fabric) => fabric.create();

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
