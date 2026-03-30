import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';

final _setupRoutes = {
  NativeLocaleRoute.name,
  LearningLocaleRoute.name,
  CEFRLevelRoute.name,
  AICredentialsRoute.name,
  TTSCredentialsRoute.name,
  PronunciationAssessmentCredentialsRoute.name,
};

@injectable
class NativeLocaleGuard extends AutoRouteGuard {
  final LocaleSettingsService _localeSettings;

  NativeLocaleGuard(this._localeSettings);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_localeSettings.nativeLocale.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        NativeLocaleRoute(
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

@injectable
class LearningLocaleGuard extends AutoRouteGuard {
  final LocaleSettingsService _localeSettings;

  LearningLocaleGuard(this._localeSettings);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_localeSettings.learningLocale.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        LearningLocaleRoute(
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

@injectable
class CEFRLevelGuard extends AutoRouteGuard {
  final LocaleSettingsService _localeSettings;

  CEFRLevelGuard(this._localeSettings);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_localeSettings.currentTargetLanguageCEFR.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        CEFRLevelRoute(
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

@injectable
class AICredentialsGuard extends AutoRouteGuard {

  final AICredentialsService _aiCredentials;

  AICredentialsGuard(this._aiCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_aiCredentials.apiKey.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        AICredentialsRoute(
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

@injectable
class PronunciationAssessmentCredentialsGuard extends AutoRouteGuard {
  final PronunciationAssessmentCredentialsService _credentials;

  PronunciationAssessmentCredentialsGuard(this._credentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_credentials.apiKey.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        PronunciationAssessmentCredentialsRoute(
          isSetupFlow: true,
          onComplete: () {
            if (!isResolved) {
              isResolved = true;
              resolver.next(true);
            }
          },
        ),
      );
    } else {
      resolver.next(true);
    }
  }
}

@injectable
class TTSCredentialsGuard extends AutoRouteGuard {
  final TextToSpeechSettingsService _ttsCredentials;

  TTSCredentialsGuard(this._ttsCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_ttsCredentials.apiKey.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        TTSCredentialsRoute(
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
