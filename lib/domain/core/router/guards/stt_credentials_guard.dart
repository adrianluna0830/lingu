import 'package:auto_route/auto_route.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/settings/services/stt_credentials_service.dart';

class STTCredentialsGuard extends AutoRouteGuard {
  final STTCredentialsService _sttCredentials;

  STTCredentialsGuard(this._sttCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_sttCredentials.apiKey.value == null) {
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
