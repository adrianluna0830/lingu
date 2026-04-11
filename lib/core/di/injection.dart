import 'package:get_it/get_it.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/ai/gemini/gemini_fabric.dart';
import 'package:lingu/core/audio/misc/i_audio_merger.dart';
import 'package:lingu/core/audio/misc/i_audio_utils.dart';
import 'package:lingu/core/audio/pcm/pcm_audio_merger.dart';
import 'package:lingu/core/audio/pcm/pcm_to_wav_audio_saver.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/audio/playback/just_audio_player_manager.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/core/audio/record/universal_pcm_recorder.dart';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/pronunciation/pronunciation_assessment_fabric.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/core/router/guards/chat_guard.dart';
import 'package:lingu/core/router/guards/home_guard.dart';
import 'package:lingu/core/router/guards/login_guards.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/core/settings/stores.dart';
import 'package:lingu/core/settings/stt_credentials_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';
import 'package:lingu/core/stt/google_speech_to_text_fabric.dart';
import 'package:lingu/core/stt/i_speech_to_text_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/tts/google/google_tts_fabric.dart';
import 'package:lingu/features/chat/chat_view.dart';
import 'package:lingu/features/chat/di/chat_languages.dart';
import 'package:lingu/features/chat/logic/chatbot/chatbot_service.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_manager.dart';
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_manager.dart';
import 'package:lingu/features/chat/logic/input/audio_input_handler.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/topics/repository/topics_repository.dart';
import 'package:lingu/features/topics/topics_manager.dart';

final di = GetIt.instance;

class DependencyInjection {
  static Future<void> init() async {
    _StartupDependencies.registerInfrastructure();

    await di.allReady();

    _StartupDependencies.registerAudioAndFabrics();
    _StartupDependencies.registerNavigationAndManagers();
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
  }

  static void registerAudioAndFabrics() {
    di.registerSingleton<IAudioRecorder>(UniversalPCMRecorder());
    di.registerSingleton<IAudioPathSaver>(PCMToWavAudioSaver());
    di.registerSingleton<IAudioMerger>(PCMAudioMerger());
    di.registerSingleton<IAudioPlayerManager>(JustAudioPlayerManager());

    di.registerFactory<IPronunciationAssessmentFabric>(
      () => PronunciationAssessmentFabric(
        di<PronunciationAssessmentCredentialsService>(),
      ),
    );
    di.registerLazySingleton<ISTTFabric>(
      () => GoogleSpeechToTextFabric(di<STTCredentialsService>()),
    );
    di.registerSingleton<IAIFabric>(
      GeminiFabric(di<AICredentialsService>()),
    );
    di.registerFactory<ITTSFabric>(
      () => GoogleTTSFabric(di<TextToSpeechSettingsService>()),
    );
  }

  static void registerNavigationAndManagers() {
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
      ),
    );

    di.registerFactory<ChatbotService>(() => ChatbotService());
    di.registerFactory<TopicsManager>(
      () => TopicsManager(
        di<TopicDataRepository>(),
        di<LocaleSettingsService>(),
      ),
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
    di.registerLazySingleton<PronunciationFeedbackManager>(
      () => PronunciationFeedbackManager(
        di<IPronunciationAssessmentService>(),
        di<IAIService>(),
        di<ISpeechToTextService>(),
        di<ChatLanguages>(),
      ),
    );
    di.registerLazySingleton<StatementFeedbackManager>(
      () => StatementFeedbackManager(di<IAIService>(), di<ChatLanguages>()),
    );
    di.registerSingleton<MessageDetailsManager>(
      MessageDetailsManager(
        di<ChatMessagesManager>(),
        di<PronunciationFeedbackManager>(),
        di<StatementFeedbackManager>(),
      ),
    );
    di.registerSingleton<PanelManager>(
      PanelManager(di<MessageDetailsManager>()),
    );
  }

  static void registerUIAndInput() {
    di.registerLazySingleton<MessageViewDTOComputed>(
      () => MessageViewDTOComputed(
        chatMessagesManager: di<ChatMessagesManager>(),
        messageDetailsManager: di<MessageDetailsManager>(),
      ),
    );
    di.registerFactory<AudioInputHandler>(
      () => AudioInputHandler(
        di<ChatMessagesManager>(),
        di<IAudioRecorder>(),
        di<IAudioPlayerManager>(),
        di<IAudioPathSaver>(),
        di<IAudioMerger>(),
      ),
    );
  }
}
