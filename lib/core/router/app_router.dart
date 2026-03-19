import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/features/home/home_view.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
  ];
}
