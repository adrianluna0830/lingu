import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

@injectable
class ChatGuard extends AutoRouteGuard {
  @override
  FutureOr<void> onNavigation(NavigationResolver resolver, StackRouter router) {
    resolver.next(true);
  }

}
