// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lingu/core/ai/core/i_ai_model.dart' as _i250;
import 'package:lingu/core/ai/gemini/gemini_fabric.dart' as _i915;
import 'package:lingu/core/audio/misc/i_audio_merger.dart' as _i645;
import 'package:lingu/core/audio/misc/i_audio_utils.dart' as _i303;
import 'package:lingu/core/audio/pcm/pcm_audio_merger.dart' as _i491;
import 'package:lingu/core/audio/pcm/pcm_to_wav_audio_saver.dart' as _i240;
import 'package:lingu/core/audio/playback/i_audio_playback.dart' as _i65;
import 'package:lingu/core/audio/playback/just_audio_player_manager.dart'
    as _i198;
import 'package:lingu/core/audio/record/i_audio_recorder.dart' as _i709;
import 'package:lingu/core/audio/record/universal_pcm_recorder.dart' as _i601;
import 'package:lingu/core/interfaces/i_fabric.dart' as _i939;
import 'package:lingu/core/router/app_router.dart' as _i1036;
import 'package:lingu/core/router/guards/chat_guard.dart' as _i503;
import 'package:lingu/core/router/guards/home_guard.dart' as _i597;
import 'package:lingu/core/router/guards/login_guards.dart' as _i1033;
import 'package:lingu/core/settings/ai_credentials_service.dart' as _i85;
import 'package:lingu/core/settings/locale_settings_service.dart' as _i56;
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart'
    as _i1042;
import 'package:lingu/core/settings/stores.dart' as _i140;
import 'package:lingu/core/settings/text_to_speech_settings_service.dart'
    as _i711;
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart' as _i648;
import 'package:lingu/core/tts/google/google_tts_fabric.dart' as _i573;
import 'package:lingu/features/chat/di/chat_languages.dart' as _i522;
import 'package:lingu/features/chat/di/chat_module.dart' as _i437;
import 'package:lingu/features/chat/logic/chatbot/chatbot_service.dart'
    as _i1003;
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart'
    as _i98;
import 'package:lingu/features/chat/logic/feedback/services/pronunciation_feedback_service.dart'
    as _i847;
import 'package:lingu/features/chat/logic/feedback/services/statement_feedback_service.dart'
    as _i228;
import 'package:lingu/features/chat/logic/input/audio_input_handler.dart'
    as _i86;
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart'
    as _i433;
import 'package:lingu/features/chat/logic/panel/panel_manager.dart' as _i420;
import 'package:lingu/features/topics/repository/topics_repository.dart'
    as _i652;
import 'package:lingu/features/topics/topics_manager.dart' as _i211;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i597.HomeGuard>(() => _i597.HomeGuard());
    gh.factory<_i1003.ChatbotService>(() => _i1003.ChatbotService());
    gh.singleton<_i140.SecureStore>(() => _i140.SecureStore());
    gh.singleton<_i140.SharedPreferencesStore>(
      () => _i140.SharedPreferencesStore(),
    );
    await gh.singletonAsync<_i652.TopicDataRepository>(
      () => _i652.TopicDataRepository.create(),
      preResolve: true,
    );
    gh.singleton<_i709.IAudioRecorder>(() => _i601.UniversalPCMRecorder());
    gh.singleton<_i303.IAudioPathSaver>(() => _i240.PCMToWavAudioSaver());
    gh.singleton<_i645.IAudioMerger>(() => _i491.PCMAudioMerger());
    gh.singleton<_i65.IAudioPlayerManager>(
      () => _i198.JustAudioPlayerManager(),
    );
    await gh.singletonAsync<_i1042.PronunciationAssessmentCredentialsService>(
      () => _i1042.PronunciationAssessmentCredentialsService.create(
        gh<_i140.SecureStore>(),
        gh<_i140.SharedPreferencesStore>(),
      ),
      preResolve: true,
    );
    gh.factory<_i1033.PronunciationAssessmentCredentialsGuard>(
      () => _i1033.PronunciationAssessmentCredentialsGuard(
        gh<_i1042.PronunciationAssessmentCredentialsService>(),
      ),
    );
    await gh.singletonAsync<_i85.AICredentialsService>(
      () => _i85.AICredentialsService.create(gh<_i140.SecureStore>()),
      preResolve: true,
    );
    await gh.singletonAsync<_i56.LocaleSettingsService>(
      () =>
          _i56.LocaleSettingsService.create(gh<_i140.SharedPreferencesStore>()),
      preResolve: true,
    );
    await gh.singletonAsync<_i711.TextToSpeechSettingsService>(
      () => _i711.TextToSpeechSettingsService.create(
        gh<_i140.SharedPreferencesStore>(),
      ),
      preResolve: true,
    );
    gh.factory<_i1033.NativeLocaleGuard>(
      () => _i1033.NativeLocaleGuard(gh<_i56.LocaleSettingsService>()),
    );
    gh.factory<_i1033.LearningLocaleGuard>(
      () => _i1033.LearningLocaleGuard(gh<_i56.LocaleSettingsService>()),
    );
    gh.factory<_i1033.CEFRLevelGuard>(
      () => _i1033.CEFRLevelGuard(gh<_i56.LocaleSettingsService>()),
    );
    gh.factory<_i939.IAPIFabric<_i648.ITextToSpeechService>>(
      () => _i573.GoogleTTSFabric(gh<_i711.TextToSpeechSettingsService>()),
    );
    gh.singleton<_i939.IAPIFabric<_i250.IAIModel>>(
      () => _i915.GeminiFabric(gh<_i85.AICredentialsService>()),
    );
    gh.factory<_i86.AudioInputHandler>(
      () => _i86.AudioInputHandler(
        gh<_i433.ChatMessagesManager>(),
        gh<_i709.IAudioRecorder>(),
        gh<_i65.IAudioPlayerManager>(),
        gh<_i303.IAudioPathSaver>(),
        gh<_i645.IAudioMerger>(),
      ),
    );
    gh.factory<_i1033.TTSCredentialsGuard>(
      () => _i1033.TTSCredentialsGuard(gh<_i711.TextToSpeechSettingsService>()),
    );
    gh.factory<_i1033.AICredentialsGuard>(
      () => _i1033.AICredentialsGuard(gh<_i85.AICredentialsService>()),
    );
    gh.factory<_i503.ChatGuard>(
      () => _i503.ChatGuard(
        gh<_i85.AICredentialsService>(),
        gh<_i711.TextToSpeechSettingsService>(),
        gh<_i56.LocaleSettingsService>(),
      ),
    );
    gh.factory<_i211.TopicsManager>(
      () => _i211.TopicsManager(
        gh<_i652.TopicDataRepository>(),
        gh<_i56.LocaleSettingsService>(),
      ),
    );
    gh.singleton<_i1036.AppRouter>(
      () => _i1036.AppRouter(
        gh<_i1033.NativeLocaleGuard>(),
        gh<_i1033.LearningLocaleGuard>(),
        gh<_i1033.CEFRLevelGuard>(),
        gh<_i1033.AICredentialsGuard>(),
        gh<_i1033.PronunciationAssessmentCredentialsGuard>(),
        gh<_i1033.TTSCredentialsGuard>(),
        gh<_i503.ChatGuard>(),
        gh<_i597.HomeGuard>(),
      ),
    );
    return this;
  }

  // initializes the registration of chat-scope dependencies inside of GetIt
  Future<_i174.GetIt> initChatScope({_i174.ScopeDisposeFunc? dispose}) async {
    return _i526.GetItHelper(this).initScopeAsync(
      'chat',
      dispose: dispose,
      init: (_i526.GetItHelper gh) async {
        final chatModule = _$ChatModule();
        await gh.factoryAsync<_i250.IAIModel>(
          () => chatModule.getAIModel(gh<_i939.IAPIFabric<_i250.IAIModel>>()),
          preResolve: true,
        );
        gh.factory<_i847.PronunciationFeedbackService>(
          () => _i847.PronunciationFeedbackService(),
        );
        await gh.factoryAsync<_i648.ITextToSpeechService>(
          () => chatModule.getTTS(
            gh<_i939.IAPIFabric<_i648.ITextToSpeechService>>(),
          ),
          preResolve: true,
        );
        gh.factory<_i522.ChatLanguages>(
          () => chatModule.getChatLanguages(gh<_i56.LocaleSettingsService>()),
        );
        gh.factory<_i228.StatementFeedbackService>(
          () => _i228.StatementFeedbackService(
            gh<_i250.IAIModel>(),
            gh<_i522.ChatLanguages>(),
          ),
        );
        gh.singleton<_i98.MessageDetailsManager>(
          () => _i98.MessageDetailsManager(
            gh<_i847.PronunciationFeedbackService>(),
            gh<_i228.StatementFeedbackService>(),
          ),
        );
        gh.singleton<_i433.ChatMessagesManager>(
          () => _i433.ChatMessagesManager(
            gh<_i98.MessageDetailsManager>(),
            gh<_i1042.PronunciationAssessmentCredentialsService>(),
          ),
        );
        gh.singleton<_i420.PanelManager>(
          () => _i420.PanelManager(gh<_i98.MessageDetailsManager>()),
        );
      },
    );
  }
}

class _$ChatModule extends _i437.ChatModule {}
