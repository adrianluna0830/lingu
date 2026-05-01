import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/core/router/guards/chat_guard.dart';
import 'package:lingu/domain/core/router/guards/home_guard.dart';
import 'package:lingu/domain/core/router/guards/locale_guards.dart';
import 'package:lingu/domain/core/router/guards/image_credentials_guard.dart';
import 'package:lingu/presentation/screens/chat/chat_view.dart';
import 'package:lingu/presentation/screens/home/home_view.dart';
import 'package:lingu/presentation/screens/home/views/main_view.dart';
import 'package:lingu/presentation/screens/home/views/settings_view.dart';
import 'package:lingu/presentation/screens/login/learning_locale_view.dart';
import 'package:lingu/presentation/screens/login/cefr_level_view.dart';
import 'package:lingu/presentation/screens/login/native_locale_view.dart';
import 'package:lingu/presentation/screens/home/views/topics_view.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:lingu/presentation/screens/login/pixabay_credentials_view.dart';
import 'package:lingu/presentation/screens/word/word_fetch_view.dart';
import 'package:lingu/presentation/screens/word/word_view.dart';

import 'package:lingu/domain/core/router/guards/unified_credentials_guard.dart';
import 'package:lingu/presentation/screens/login/login_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  final NativeLocaleGuard _nativeLocaleGuard;
  final LearningLocaleGuard _learningLocaleGuard;
  final CEFRLevelGuard _cefrLevelGuard;
  final UnifiedCredentialsGuard _unifiedCredentialsGuard;
  final ChatGuard _chatGuard;
  final HomeGuard _homeGuard;
  final ImageCredentialsGuard _imageCredentialsGuard;

  AppRouter(
    this._nativeLocaleGuard,
    this._learningLocaleGuard,
    this._cefrLevelGuard,
    this._unifiedCredentialsGuard,
    this._chatGuard,
    this._homeGuard,
    this._imageCredentialsGuard,
  );

  @override
  List<AutoRouteGuard> get guards => [
    _nativeLocaleGuard,
    _learningLocaleGuard,
    _cefrLevelGuard,
    _unifiedCredentialsGuard,
    _imageCredentialsGuard,
  ];
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: NativeLocaleRoute.page),
    AutoRoute(page: TopicsRoute.page),
    AutoRoute(page: LearningLocaleRoute.page),
    AutoRoute(page: CEFRLevelRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: WordRoute.page),
    AutoRoute(page: WordFetchRoute.page),

    AutoRoute(
      page: HomeRoute.page,
      initial: true,
      guards: [_homeGuard],
      children: [
        AutoRoute(page: MainRoute.page, initial: true),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: TopicsRoute.page),
      ],
    ),
    AutoRoute(page: ChatRoute.page, guards: [_chatGuard]),
  ];
}
