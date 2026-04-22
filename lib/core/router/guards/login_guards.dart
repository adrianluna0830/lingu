import 'package:auto_route/auto_route.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/image_credentials_service.dart';
import 'package:lingu/core/settings/stt_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';

final _setupRoutes = {
  NativeLocaleRoute.name,
  LearningLocaleRoute.name,
  CEFRLevelRoute.name,
  AICredentialsRoute.name,
  STTCredentialsRoute.name,
  TTSCredentialsRoute.name,
  PronunciationAssessmentCredentialsRoute.name,
  PixabayCredentialsRoute.name,
};

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

class STTCredentialsGuard extends AutoRouteGuard {
  final STTCredentialsService _sttCredentials;

  STTCredentialsGuard(this._sttCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_sttCredentials.apiKey.value == null) {
      bool isResolved = false;
      resolver.redirectUntil(
        STTCredentialsRoute(
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

class ImageCredentialsGuard extends AutoRouteGuard {
  final ImageCredentialsService _imageCredentials;

  ImageCredentialsGuard(this._imageCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (_setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    resolver.next(true);
  }
}
