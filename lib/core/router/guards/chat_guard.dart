import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';

class ChatGuard extends AutoRouteGuard {
  final AICredentialsService _aiCredentials;
  final TextToSpeechSettingsService _ttsSettings;
  final LocaleSettingsService _localeSettings;

  ChatGuard(
    this._aiCredentials,
    this._ttsSettings,
    this._localeSettings,
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

        await DependencyInjection.initChatScope();

        resolver.next(true);
      } catch (e) {
        try {
           await di.popScopesTill('chat', inclusive: true);
        } catch (_) {}
        
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
