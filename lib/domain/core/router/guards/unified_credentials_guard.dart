import 'package:auto_route/auto_route.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/settings/services/open_router_settings_service.dart';
import 'package:lingu/domain/settings/services/microsoft_settings_service.dart';
import 'package:lingu/domain/settings/services/replicate_settings_service.dart';

class UnifiedCredentialsGuard extends AutoRouteGuard {
  final OpenRouterSettingsService _openRouter;
  final MicrosoftSettingsService _microsoft;
  final ReplicateSettingsService _replicate;

  UnifiedCredentialsGuard(this._openRouter, this._microsoft, this._replicate);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    if (!_openRouter.isConfigured || !_microsoft.isConfigured || !_replicate.isConfigured) {
      bool isResolved = false;
      resolver.redirectUntil(
        LoginRoute(
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
