import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/settings/services/open_router_settings_service.dart';
import 'package:lingu/domain/settings/services/microsoft_settings_service.dart';
import 'package:lingu/domain/settings/services/replicate_settings_service.dart';
import 'package:lingu/domain/settings/services/locale_settings_service.dart';

class ChatGuard extends AutoRouteGuard {
  final OpenRouterSettingsService _openRouter;
  final MicrosoftSettingsService _microsoft;
  final ReplicateSettingsService _replicate;
  final LocaleSettingsService _localeSettings;

  ChatGuard(
    this._openRouter,
    this._microsoft,
    this._replicate,
    this._localeSettings,
  );

  @override
  FutureOr<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final aiConfigured = _openRouter.isConfigured;
    final microsoftConfigured = _microsoft.isConfigured;
    final replicateConfigured = _replicate.isConfigured;
    final localesConfigured = _localeSettings.isConfigured;

    if (aiConfigured &&
        microsoftConfigured &&
        replicateConfigured &&
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
