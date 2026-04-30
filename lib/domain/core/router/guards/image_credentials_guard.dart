import 'package:auto_route/auto_route.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/settings/services/image_credentials_service.dart';

class ImageCredentialsGuard extends AutoRouteGuard {
  final ImageCredentialsService _imageCredentials;

  ImageCredentialsGuard(this._imageCredentials);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (setupRoutes.contains(resolver.routeName)) {
      resolver.next(true);
      return;
    }

    resolver.next(true);
  }
}
