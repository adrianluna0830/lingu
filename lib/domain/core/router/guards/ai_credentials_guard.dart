import 'package:auto_route/auto_route.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/settings/services/ai_credentials_service.dart';

class AICredentialsGuard extends AutoRouteGuard {
  final AICredentialsService _aiCredentials;

  AICredentialsGuard(this._aiCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (_aiCredentials.apiKey.value == null) {
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
