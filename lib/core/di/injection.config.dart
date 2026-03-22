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
import 'package:lingu/core/ai/core/i_ai_model_fabric.dart' as _i691;
import 'package:lingu/core/ai/gemini/gemini_fabric.dart' as _i915;
import 'package:lingu/core/audio/playback/i_audio_playback.dart' as _i65;
import 'package:lingu/core/audio/playback/just_audio_player_manager.dart'
    as _i198;
import 'package:lingu/core/audio/record/audio_recorder.dart' as _i109;
import 'package:lingu/core/audio/record/i_audio_recorder.dart' as _i709;
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
import 'package:lingu/core/tts/core/i_tts_fabric.dart' as _i42;
import 'package:lingu/core/tts/google/google_tts_fabric.dart' as _i573;
import 'package:lingu/features/chat/logic/panel/panel_manager.dart' as _i420;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i597.HomeGuard>(() => _i597.HomeGuard());
    gh.singleton<_i140.SecureStore>(() => _i140.SecureStore());
    gh.singleton<_i140.SharedPreferencesStore>(
      () => _i140.SharedPreferencesStore(),
    );
    gh.singleton<_i420.PanelManager>(() => _i420.PanelManager());
    gh.singleton<_i709.IAudioRecorder>(() => _i109.AudioRecorder());
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
    gh.singleton<_i691.IAIModelFabric>(
      () => _i915.GeminiFabric(gh<_i85.AICredentialsService>()),
    );
    gh.factory<_i42.ITTSFabric>(
      () => _i573.GoogleTTSFabric(gh<_i711.TextToSpeechSettingsService>()),
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
        gh<_i691.IAIModelFabric>(),
        gh<_i42.ITTSFabric>(),
      ),
    );
    gh.singleton<_i1036.AppRouter>(
      () => _i1036.AppRouter(
        gh<_i1033.NativeLocaleGuard>(),
        gh<_i1033.LearningLocaleGuard>(),
        gh<_i1033.AICredentialsGuard>(),
        gh<_i1033.PronunciationAssessmentCredentialsGuard>(),
        gh<_i1033.TTSCredentialsGuard>(),
        gh<_i503.ChatGuard>(),
        gh<_i597.HomeGuard>(),
      ),
    );
    return this;
  }
}
