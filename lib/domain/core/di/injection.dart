import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:lingu/datasources/implementations/pronunciation_assessment/pronunciation_assessment_fabric.dart';
import 'package:lingu/domain/word/managers/word_managers.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/datasources/implementations/ai/gemini/gemini_fabric.dart';
import 'package:lingu/domain/interfaces/audio_utils/i_audio_utils.dart';
import 'package:lingu/datasources/implementations/audio_utils/pcm_audio_utils.dart';
import 'package:lingu/domain/interfaces/audio_playback/i_audio_playback.dart';
import 'package:lingu/datasources/implementations/playback/just_audio_player_manager.dart';
import 'package:lingu/domain/interfaces/audio_recorder/i_audio_recorder.dart';
import 'package:lingu/datasources/implementations/record/universal_pcm_recorder.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/interfaces/pronunciation_assessment/i_pronunciation_assessment.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/core/router/guards/chat_guard.dart';
import 'package:lingu/domain/core/router/guards/home_guard.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/core/router/guards/image_credentials_guard.dart';
import 'package:lingu/domain/settings/services/ai_credentials_service.dart';
import 'package:lingu/domain/settings/services/image_credentials_service.dart';
import 'package:lingu/domain/settings/services/locale_settings_service.dart';
import 'package:lingu/domain/settings/services/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/domain/settings/stores.dart';
import 'package:lingu/domain/settings/services/stt_credentials_service.dart';
import 'package:lingu/domain/settings/services/text_to_speech_settings_service.dart';
import 'package:lingu/datasources/implementations/stt/google/google_speech_to_text_fabric.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/datasources/implementations/tts/qwen_azure/qwen_azure_tts_fabric.dart';
import 'package:lingu/domain/interfaces/image_finder/i_image_finder.dart';
import 'package:lingu/datasources/implementations/image_finder/pixabay_image_fabric.dart';
import 'package:lingu/domain/word/managers/i_word_manager.dart';
import 'package:lingu/domain/word/repositories/word_repository.dart';
import 'package:lingu/domain/chat/models/chat/chat_cefr.dart';
import 'package:lingu/domain/chat/models/chat/chat_languages.dart';
import 'package:lingu/domain/chat/managers/chatbot_manager.dart';
import 'package:lingu/domain/chat/services/chat_orchestrator.dart';
import 'package:lingu/domain/chat/managers/message_details_manager.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/domain/chat/services/pronunciation_feedback_service.dart';
import 'package:lingu/domain/chat/services/statement_feedback_service.dart';
import 'package:lingu/domain/chat/managers/audio_input_manager.dart';
import 'package:lingu/domain/chat/managers/chat_panel_manager.dart';
import 'package:lingu/domain/chat/managers/chat_messages_manager.dart';
import 'package:lingu/domain/chat/managers/panel_manager.dart';
import 'package:lingu/presentation/screens/chat/components/message_details/ai_audio_message_details.dart';
import 'package:lingu/domain/chat/managers/chat_message_view_manager.dart';
import 'package:lingu/domain/topic/repositories/topics_repository.dart';
import 'package:lingu/domain/topic/managers/topics_manager.dart';
import 'package:lingu/domain/word/models/word.dart';

import 'package:lingu/domain/audio/managers/sound_manager.dart';
import 'package:lingu/domain/audio/managers/audio_player_manager.dart';

import 'package:lingu/domain/core/router/guards/unified_credentials_guard.dart';
import 'package:lingu/datasources/implementations/ai/open_router/open_router_fabric.dart';
import 'package:lingu/datasources/implementations/pronunciation_assessment/microsoft_fabric.dart';
import 'package:lingu/datasources/implementations/stt/replicate/replicate_fabric.dart';
import 'package:lingu/domain/settings/services/open_router_settings_service.dart';
import 'package:lingu/domain/settings/services/microsoft_settings_service.dart';
import 'package:lingu/domain/settings/services/replicate_settings_service.dart';

import 'package:lingu/domain/interfaces/ai/i_ai_schema_service.dart';
import 'package:lingu/datasources/implementations/ai/ai_schema_service.dart';

final di = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _StartupDependencies.registerInfrastructure();

    await di.allReady();

    await _StartupDependencies.registerAudioAndFabrics();
    _StartupDependencies.registerNavigationAndManagers();

    await di.allReady();
  }

  static Future<void> initChatScope() async {
    if (!di.hasScope('chat')) {
      await di.pushNewScopeAsync(
        scopeName: 'chat',
        init: (di) async {
          _ChatDependencies.registerCore();

          await di.allReady();

          _ChatDependencies.registerLogic();
          _ChatDependencies.registerUIAndInput();

          await di.allReady();
        },
      );
    }
  }

  static Future<void> disposeChatScope() async {
    if (di.hasScope('chat')) {
      await di.popScope();
    }
  }
}

class _StartupDependencies {
  static void registerInfrastructure() {
    di.registerSingleton<SecureStore>(SecureStore());
    di.registerSingleton<SharedPreferencesStore>(SharedPreferencesStore());
    di.registerSingleton<IAiSchemaService>(AiSchemaService());

    // New unified services
    di.registerSingletonAsync<OpenRouterSettingsService>(() => OpenRouterSettingsService.create(di<SecureStore>()));
    di.registerSingletonAsync<MicrosoftSettingsService>(() => MicrosoftSettingsService.create(di<SecureStore>(), di<SharedPreferencesStore>()));
    di.registerSingletonAsync<ReplicateSettingsService>(() => ReplicateSettingsService.create(di<SecureStore>()));

    // Keep old ones just in case as requested
    di.registerSingletonAsync<PronunciationAssessmentCredentialsService>(() => PronunciationAssessmentCredentialsService.create(di<SecureStore>(), di<SharedPreferencesStore>()));
    di.registerSingletonAsync<AICredentialsService>(() => AICredentialsService.create(di<SecureStore>()));
    di.registerSingletonAsync<ImageCredentialsService>(() => ImageCredentialsService.create(di<SecureStore>()));
    di.registerSingletonAsync<STTCredentialsService>(() => STTCredentialsService.create(di<SecureStore>()));

    di.registerSingletonAsync<LocaleSettingsService>(() => LocaleSettingsService.create(di<SharedPreferencesStore>()));
    di.registerSingletonAsync<TextToSpeechSettingsService>(() => TextToSpeechSettingsService.create(di<SharedPreferencesStore>()));
    di.registerSingletonAsync<TopicDataRepository>(() => TopicDataRepository.create());

    di.registerSingletonAsync<EnglishWordRepository>(() => EnglishWordRepository.create());
    di.registerSingletonAsync<GermanWordRepository>(() => GermanWordRepository.create());
    di.registerSingletonAsync<SpanishWordRepository>(() => SpanishWordRepository.create());
  }

  static Future<void> registerAudioAndFabrics() async {
    di.registerSingleton<IAudioUtils>(PCMAudioUtils());
    di.registerSingleton<IAudioRecorder>(UniversalPCMRecorder(di<IAudioUtils>()));
    di.registerSingleton<IAudioPlayerManager>(JustAudioPlayerManager());
    di.registerSingleton<SoundManager>(SoundManager());
    di.registerSingleton<AudioPlayerManager>(AudioPlayerManager(di<SoundManager>(), di<IAudioPlayerManager>()));

    // Use new fabrics
    di.registerFactory<IAPIFabric<IAIService>>(() => OpenRouterFabric(di<OpenRouterSettingsService>()));
    di.registerLazySingleton<IAPIFabric<ISpeechToTextService>>(() => ReplicateFabric(di<ReplicateSettingsService>()));

    // Microsoft related services still use their own fabrics but pointing to new settings or old ones
    // To strictly follow "un fabric por servicio en este caso 3" for UI, I'll register the MicrosoftFabric too
    di.registerFactory<MicrosoftFabric>(() => MicrosoftFabric(di<MicrosoftSettingsService>()));

    di.registerFactory<IAPIFabric<IPronunciationAssessmentService>>(() => PronunciationAssessmentFabric(di<PronunciationAssessmentCredentialsService>()));
    di.registerFactory<IAPIFabric<ITextToSpeechService>>(() => QwenAzureTTSFabric(di<TextToSpeechSettingsService>()));

    di.registerSingleton<IAPIFabric<IImageFinder>>(PixabayImageFabric(di<ImageCredentialsService>()));

    final imageFinder = await di<IAPIFabric<IImageFinder>>().create();
    di.registerSingleton<IImageFinder>(imageFinder);
  }

  static void registerNavigationAndManagers() {
    di.registerFactory<UnifiedCredentialsGuard>(() => UnifiedCredentialsGuard(di<OpenRouterSettingsService>(), di<MicrosoftSettingsService>(), di<ReplicateSettingsService>()));
    di.registerFactory<NativeLocaleGuard>(() => NativeLocaleGuard(di<LocaleSettingsService>()));
    di.registerFactory<LearningLocaleGuard>(() => LearningLocaleGuard(di<LocaleSettingsService>()));
    di.registerFactory<CEFRLevelGuard>(() => CEFRLevelGuard(di<LocaleSettingsService>()));
    di.registerFactory<ImageCredentialsGuard>(() => ImageCredentialsGuard(di<ImageCredentialsService>()));

    di.registerFactory<ChatGuard>(() => ChatGuard(di<OpenRouterSettingsService>(), di<MicrosoftSettingsService>(), di<ReplicateSettingsService>(), di<LocaleSettingsService>()));
    di.registerFactory<HomeGuard>(() => HomeGuard());

    di.registerSingleton<AppRouter>(
      AppRouter(di<NativeLocaleGuard>(), di<LearningLocaleGuard>(), di<CEFRLevelGuard>(), di<UnifiedCredentialsGuard>(), di<ChatGuard>(), di<HomeGuard>(), di<ImageCredentialsGuard>()),
    );

    di.registerFactory<TopicsManager>(() => TopicsManager(di<TopicDataRepository>(), di<LocaleSettingsService>()));

    di.registerFactoryParam<IWordManager<Word, dynamic>, LanguageLocale, void>((locale, _) {
      final aiService = di<IAIService>();
      final ttsService = di<ITextToSpeechService>();
      final sttService = di<ISpeechToTextService>();
      final audioUtils = di<IAudioUtils>();
      final imageFinder = di.isRegistered<IImageFinder>() ? di<IImageFinder>() : null;

      if (locale == LanguageLocale.en) {
        return EnglishWordManager(aiService, ttsService, sttService, audioUtils, di<EnglishWordRepository>(), imageFinder);
      } else if (locale == LanguageLocale.de) {
        return GermanWordManager(aiService, ttsService, sttService, audioUtils, di<GermanWordRepository>(), imageFinder);
      } else if (locale == LanguageLocale.es) {
        return SpanishWordManager(aiService, ttsService, sttService, audioUtils, di<SpanishWordRepository>(), imageFinder);
      }
      throw Exception("Locale not supported: $locale");
    });
  }
}

class _ChatDependencies {
  static void registerCore() {
    di.registerSingleton<ChatMessagesManager>(ChatMessagesManager());

    di.registerSingleton<ChatLanguages>(() {
      final service = di<LocaleSettingsService>();
      final native = service.nativeLocale.value;
      final target = service.learningLocale.value;
      if (native == null || target == null) {
        throw Exception("Chat languages not configured");
      }
      return ChatLanguages(native: native, target: target);
    }());

    di.registerSingleton<ChatCEFR>(() {
      final service = di<LocaleSettingsService>();
      final level = service.currentTargetLanguageCEFR.value;
      if (level == null) {
        throw Exception("CEFR level not configured");
      }
      return ChatCEFR(level);
    }());

    di.registerSingletonAsync<IAIService>(() async => await di<IAPIFabric<IAIService>>().create());
    di.registerSingletonAsync<IPronunciationAssessmentService>(() async => await di<IAPIFabric<IPronunciationAssessmentService>>().create());

    di.registerSingletonAsync<ITextToSpeechService>(() async => await di<IAPIFabric<ITextToSpeechService>>().create());
    di.registerSingletonAsync<ISpeechToTextService>(() async => await di<IAPIFabric<ISpeechToTextService>>().create());
  }

  static void registerLogic() {
    di.registerLazySingleton<PronunciationFeedbackService>(
      () => PronunciationFeedbackService(di<IPronunciationAssessmentService>(), di<IAIService>(), di<ISpeechToTextService>(), di<IAudioUtils>(), di<ChatLanguages>(), di<ITextToSpeechService>()),
    );
    di.registerLazySingleton<StatementFeedbackService>(() => StatementFeedbackService(di<IAIService>(), di<ChatLanguages>()));
    di.registerSingleton<MessageDetailsManager>(MessageDetailsManager(di<PronunciationFeedbackService>(), di<StatementFeedbackService>()));
    di.registerSingletonAsync<ChatbotManager>(() async => ChatbotManager(di<IAIService>(), di<ITextToSpeechService>(), di<ISpeechToTextService>(), di<ChatLanguages>(), di<ChatCEFR>()));
    di.registerSingleton<ChatMessageViewManager>(ChatMessageViewManager());
    di.registerSingletonAsync<ChatOrchestrator>(() async {
      await di.isReady<ChatbotManager>();
      await di.isReady<IAIService>();
      return ChatOrchestrator(di<ChatMessagesManager>(), di<MessageDetailsManager>(), di<ChatbotManager>(), di<ChatMessageViewManager>(), di<IAIService>(), di<ChatLanguages>(), di<IAudioUtils>());
    });
    di.registerSingleton<PanelManager>(PanelManager(di<MessageDetailsManager>()));
    di.registerSingleton<ChatPanelManager>(ChatPanelManager(di<IAIService>()));
  }

  static void registerUIAndInput() {
    di.registerFactoryParam<AIAudioMessageDetailsInternalController, SpeechAudio, void>((data, _) => AIAudioMessageDetailsInternalController(data, di<AudioPlayerManager>()));

    di.registerFactory<AudioInputManager>(() => AudioInputManager(di<ChatOrchestrator>(), di<IAudioRecorder>(), di<AudioPlayerManager>(), di<IAudioUtils>()));
  }
}
