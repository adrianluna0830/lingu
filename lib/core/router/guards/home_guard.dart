import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/di/injection.dart';

@injectable
class HomeGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    if (di.hasScope('chat')) {
      await di.popScopesTill('chat', inclusive: true);
    }
    
    resolver.next(true);
  }
}
