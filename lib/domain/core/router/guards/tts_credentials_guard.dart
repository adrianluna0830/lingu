import 'package:auto_route/auto_route.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/settings/services/text_to_speech_settings_service.dart';

class TTSCredentialsGuard extends AutoRouteGuard {
  final TextToSpeechSettingsService _ttsCredentials;

  TTSCredentialsGuard(this._ttsCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_ttsCredentials.replicateApiKey.value == null ||
        _ttsCredentials.azureApiKey.value == null ||
        _ttsCredentials.azureRegion.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        LoginRoute(
          isSetupFlow: true,
          onComplete: () {
          if (!isResolved) {
            isResolved = true;
            resolver.next(true);
          }
        }),
      );
    } else {
      resolver.next(true);
    }
  }
}
