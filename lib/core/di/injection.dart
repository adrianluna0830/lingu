import 'package:get_it/get_it.dart';
import 'package:lingu/core/ai/core/i_ai_service.dart';
import 'package:lingu/core/ai/gemini/gemini_fabric.dart';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:lingu/core/audio/pcm/pcm_audio_utils.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/playback/just_audio_player_manager.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/core/audio/record/universal_pcm_recorder.dart';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/core/pronunciation/pronunciation_assessment_fabric.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/core/router/guards/chat_guard.dart';
import 'package:lingu/core/router/guards/home_guard.dart';
import 'package:lingu/core/router/guards/login_guards.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/image_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/core/settings/stores.dart';
import 'package:lingu/core/settings/stt_credentials_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';
import 'package:lingu/core/stt/google_speech_to_text_fabric.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/tts/google/google_tts_fabric.dart';
import 'package:lingu/core/image/i_image_finder.dart';
import 'package:lingu/core/image/pixabay_image_fabric.dart';
import 'package:lingu/core/word/word_manager.dart';
import 'package:lingu/core/word/word_repository.dart';
import 'package:lingu/features/chat/di/chat_cefr.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/chatbot/chatbot_manager.dart';
import 'package:lingu/features/chat/logic/chatbot/chat_orchestrator.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart';
import 'package:lingu/features/chat/logic/input/audio_input_manager.dart';
import 'package:lingu/features/chat/logic/panel/chat_panel_manager.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/ai_audio_message_details.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/logic/chat_message_view_manager.dart';
import 'package:lingu/features/topics/repository/topics_repository.dart';
import 'package:lingu/features/topics/topics_manager.dart';
import 'package:lingu/core/word/word.dart';

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

    di.registerSingletonAsync<PronunciationAssessmentCredentialsService>(
      () => PronunciationAssessmentCredentialsService.create(
        di<SecureStore>(),
        di<SharedPreferencesStore>(),
      ),
    );
    di.registerSingletonAsync<AICredentialsService>(
      () => AICredentialsService.create(di<SecureStore>()),
    );
    di.registerSingletonAsync<ImageCredentialsService>(
      () => ImageCredentialsService.create(di<SecureStore>()),
    );
    di.registerSingletonAsync<STTCredentialsService>(
      () => STTCredentialsService.create(di<SecureStore>()),
    );
    di.registerSingletonAsync<LocaleSettingsService>(
      () => LocaleSettingsService.create(di<SharedPreferencesStore>()),
    );
    di.registerSingletonAsync<TextToSpeechSettingsService>(
      () => TextToSpeechSettingsService.create(di<SharedPreferencesStore>()),
    );
    di.registerSingletonAsync<TopicDataRepository>(
      () => TopicDataRepository.create(),
    );

    di.registerSingletonAsync<EnglishWordRepository>(() => EnglishWordRepository.create());
    di.registerSingletonAsync<GermanWordRepository>(() => GermanWordRepository.create());
    di.registerSingletonAsync<SpanishWordRepository>(() => SpanishWordRepository.create());
  }

  static Future<void> registerAudioAndFabrics() async {
    di.registerSingleton<IAudioUtils>(PCMAudioUtils());
    di.registerSingleton<IAudioRecorder>(
      UniversalPCMRecorder(di<IAudioUtils>()),
    );
    di.registerSingleton<IAudioPlayerManager>(JustAudioPlayerManager());

    di.registerFactory<IPronunciationAssessmentFabric>(
      () => PronunciationAssessmentFabric(
        di<PronunciationAssessmentCredentialsService>(),
      ),
    );
    di.registerLazySingleton<ISTTFabric>(
      () => GoogleSpeechToTextFabric(di<STTCredentialsService>()),
    );
    di.registerSingleton<IAIFabric>(GeminiFabric(di<AICredentialsService>()));
    di.registerFactory<ITTSFabric>(
      () => GoogleTTSFabric(di<TextToSpeechSettingsService>()),
    );

    final imageFabric = PixabayImageFabric(di<ImageCredentialsService>());
    di.registerSingleton<PixabayImageFabric>(imageFabric);

    final imageFinder = await imageFabric.create();
    if (imageFinder != null) {
      di.registerSingleton<IImageFinder>(imageFinder);
    }
  }

  static void registerNavigationAndManagers() {
    di.registerFactory<ImageCredentialsGuard>(
      () => ImageCredentialsGuard(di<ImageCredentialsService>()),
    );
    di.registerFactory<PronunciationAssessmentCredentialsGuard>(
      () => PronunciationAssessmentCredentialsGuard(
        di<PronunciationAssessmentCredentialsService>(),
      ),
    );
    di.registerFactory<NativeLocaleGuard>(
      () => NativeLocaleGuard(di<LocaleSettingsService>()),
    );
    di.registerFactory<LearningLocaleGuard>(
      () => LearningLocaleGuard(di<LocaleSettingsService>()),
    );
    di.registerFactory<CEFRLevelGuard>(
      () => CEFRLevelGuard(di<LocaleSettingsService>()),
    );
    di.registerFactory<STTCredentialsGuard>(
      () => STTCredentialsGuard(di<STTCredentialsService>()),
    );
    di.registerFactory<TTSCredentialsGuard>(
      () => TTSCredentialsGuard(di<TextToSpeechSettingsService>()),
    );
    di.registerFactory<AICredentialsGuard>(
      () => AICredentialsGuard(di<AICredentialsService>()),
    );
    di.registerFactory<ChatGuard>(
      () => ChatGuard(
        di<AICredentialsService>(),
        di<TextToSpeechSettingsService>(),
        di<LocaleSettingsService>(),
      ),
    );
    di.registerFactory<HomeGuard>(() => HomeGuard());

    di.registerSingleton<AppRouter>(
      AppRouter(
        di<NativeLocaleGuard>(),
        di<LearningLocaleGuard>(),
        di<CEFRLevelGuard>(),
        di<AICredentialsGuard>(),
        di<STTCredentialsGuard>(),
        di<PronunciationAssessmentCredentialsGuard>(),
        di<TTSCredentialsGuard>(),
        di<ChatGuard>(),
        di<HomeGuard>(),
        di<ImageCredentialsGuard>(),
      ),
    );

    di.registerFactory<TopicsManager>(
      () =>
          TopicsManager(di<TopicDataRepository>(), di<LocaleSettingsService>()),
    );

    di.registerFactoryParam<IWordManager<Word, dynamic>, LanguageLocale, void>(
      (locale, _) {
        final aiService = di<IAIService>();
        final ttsService = di<ITextToSpeechService>();
        final audioUtils = di<IAudioUtils>();
        final imageFinder = di.isRegistered<IImageFinder>() ? di<IImageFinder>() : null;

        if (locale == LanguageLocale.en) {
          return EnglishWordManager(aiService, ttsService, audioUtils, di<EnglishWordRepository>(), imageFinder);
        } else if (locale == LanguageLocale.de) {
          return GermanWordManager(aiService, ttsService, audioUtils, di<GermanWordRepository>(), imageFinder);
        } else if (locale == LanguageLocale.es) {
          return SpanishWordManager(aiService, ttsService, audioUtils, di<SpanishWordRepository>(), imageFinder);
        }
        throw Exception("Locale not supported: $locale");
      },
    );
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

    di.registerSingletonAsync<IAIService>(
      () async => await di<IAIFabric>().create(),
    );
    di.registerSingletonAsync<IPronunciationAssessmentService>(
      () async => await di<IPronunciationAssessmentFabric>().create(),
    );
    di.registerSingletonAsync<ITextToSpeechService>(
      () async => await di<ITTSFabric>().create(),
    );
    di.registerSingletonAsync<ISpeechToTextService>(
      () async => await di<ISTTFabric>().create(),
    );
  }

  static void registerLogic() {
    di.registerLazySingleton<PronunciationFeedbackService>(
      () => PronunciationFeedbackService(
        di<IPronunciationAssessmentService>(),
        di<IAIService>(),
        di<ISpeechToTextService>(),
        di<IAudioUtils>(),
        di<ChatLanguages>(),
        di<ITextToSpeechService>(),
      ),
    );
    di.registerLazySingleton<StatementFeedbackService>(
      () => StatementFeedbackService(di<IAIService>(), di<ChatLanguages>()),
    );
    di.registerSingleton<MessageDetailsManager>(
      MessageDetailsManager(
        di<PronunciationFeedbackService>(),
        di<StatementFeedbackService>(),
      ),
    );
    di.registerSingletonAsync<ChatbotManager>(
      () async => ChatbotManager(
        di<IAIService>(),
        di<ITextToSpeechService>(),
        di<ChatLanguages>(),
        di<ChatCEFR>(),
      ),
    );
    di.registerSingleton<ChatMessageViewManager>(ChatMessageViewManager());
    di.registerSingletonAsync<ChatOrchestrator>(() async {
      await di.isReady<ChatbotManager>();
      await di.isReady<IAIService>();
      return ChatOrchestrator(
        di<ChatMessagesManager>(),
        di<MessageDetailsManager>(),
        di<ChatbotManager>(),
        di<ChatMessageViewManager>(),
        di<IAIService>(),
        di<ChatLanguages>(),
        di<IAudioUtils>(),
      );
    });
    di.registerSingleton<PanelManager>(
      PanelManager(di<MessageDetailsManager>()),
    );
    di.registerSingleton<ChatPanelManager>(
      ChatPanelManager(di<IAIService>()),
    );
  }

  static void registerUIAndInput() {
    di.registerFactoryParam<AIAudioMessageDetailsInternalController,
        AIAudioMessageDetailsViewDto, void>(
      (data, _) => AIAudioMessageDetailsInternalController(
        data,
        di<IAudioPlayerManager>(),
      ),
    );

    di.registerFactory<AudioInputManager>(
      () => AudioInputManager(
        di<ChatOrchestrator>(),
        di<IAudioRecorder>(),
        di<IAudioPlayerManager>(),
        di<IAudioUtils>(),
      ),
    );
  }
}
