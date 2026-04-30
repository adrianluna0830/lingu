import 'package:auto_route/auto_route.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/settings/services/locale_settings_service.dart';

final setupRoutes = {
  NativeLocaleRoute.name,
  LearningLocaleRoute.name,
  CEFRLevelRoute.name,
  LoginRoute.name,
};

class NativeLocaleGuard extends AutoRouteGuard {
  final LocaleSettingsService _localeSettings;

  NativeLocaleGuard(this._localeSettings);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (setupRoutes.contains(resolver.routeName)) {
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
    if (setupRoutes.contains(resolver.routeName)) {
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
    if (setupRoutes.contains(resolver.routeName)) {
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
