import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/di/injection.config.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';

@injectable
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

        di.initChatScope();

        resolver.next(true);
      } catch (e) {
        // Drop scope on error if it was partially initialized or if initChatScope threw
        try {
          // We can't easily check if scope is active, but popping it is safe?
          // Actually, if initChatScope fails, it might not have pushed the scope or might have left it half-baked.
          // initChatScope usually pushes the scope.
          // But GetIt scopes are a stack.
          // If initChatScope throws, we should try to cleanup.
          // Since we don't know the state, we can try to drop scope if we are in it?
          // But 'dropScope' is not a standard GetIt method, popScopesTill is.
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
