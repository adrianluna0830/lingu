import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/ai/core/i_ai_model_fabric.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/language_locale.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/tts/core/i_tts_fabric.dart';

import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/feedback/user_feedback_analyzer.dart';

@injectable
class ChatGuard extends AutoRouteGuard {
  final AICredentialsService _aiCredentials;
  final TextToSpeechSettingsService _ttsSettings;
  final LocaleSettingsService _localeSettings;
  final IAIModelFabric _aiFabric;
  final ITTSFabric _ttsFabric;

  ChatGuard(
    this._aiCredentials,
    this._ttsSettings,
    this._localeSettings,
    this._aiFabric,
    this._ttsFabric,
  );

  @override
  FutureOr<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final aiKey = _aiCredentials.apiKey.value;
    final ttsKey = _ttsSettings.apiKey.value;
    final localesConfigured = _localeSettings.isConfigured;

    if (aiKey != null &&
        aiKey.isNotEmpty &&
        ttsKey != null &&
        ttsKey.isNotEmpty &&
        localesConfigured) {
      try {
        try {
          await di.popScopesTill('chat', inclusive: true);
        } catch (_) {}

        GetItHelper(di).initScope(
          'chat',
          init: (gh) {
            gh.factory<IAIModel>(() => _aiFabric.create());
            gh.factory<ITextToSpeechService>(() => _ttsFabric.create());
            gh.factory<NativeLocale>(
              () => NativeLocale(_localeSettings.nativeLocale.value!),
            );
            gh.factory<TargetLocale>(
              () => TargetLocale(_localeSettings.learningLocale.value!),
            );
            gh.factory<UserFeedbackAnalyzer>(
              () => UserFeedbackAnalyzer(di<IAIModel>()),
            );
          },
        );

        resolver.next(true);
      } catch (e) {
        _showError(router, 'Error initializing chat: $e');
        resolver.next(false);
      }
    } else {
      _showError(
        router,
        'Please configure AI, TTS and language settings before starting a chat.',
      );
      resolver.next(false);
    }
  }

  void _showError(StackRouter router, String message) {
    final context = router.navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
