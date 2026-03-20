import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:googleapis/spanner/v1.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/router/guards/chat_guard.dart';
import 'package:lingu/core/router/guards/home_guard.dart';
import 'package:lingu/core/router/guards/login_guards.dart';
import 'package:lingu/features/chat/chat_view.dart';
import 'package:lingu/features/home/home_view.dart';
import 'package:lingu/features/login/ui/ai_credentials_view.dart';
import 'package:lingu/features/login/ui/learning_locale_view.dart';
import 'package:lingu/features/login/ui/native_locale_view.dart';
import 'package:lingu/features/login/ui/pronunciation_assessment_credentials_view.dart';
import 'package:lingu/features/login/ui/tts_credentials_view.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  final NativeLocaleGuard _nativeLocaleGuard;
  final LearningLocaleGuard _learningLocaleGuard;
  final AICredentialsGuard _aiCredentialsGuard;
  final PronunciationAssessmentCredentialsGuard _pronunciationAssessmentCredentialGuard;
  final TTSCredentialsGuard _ttsCredentialsGuard;
  final ChatGuard _chatGuard;
  final HomeGuard _homeGuard;

  AppRouter(
    this._nativeLocaleGuard,
    this._learningLocaleGuard,
    this._aiCredentialsGuard,
    this._pronunciationAssessmentCredentialGuard,
    this._ttsCredentialsGuard,
    this._chatGuard,
    this._homeGuard,
  );

  @override
  List<AutoRouteGuard> get guards => [
    _nativeLocaleGuard,
    _learningLocaleGuard,
    _aiCredentialsGuard,
    _pronunciationAssessmentCredentialGuard,
    _ttsCredentialsGuard,
  ];
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: NativeLocaleRoute.page),
    AutoRoute(page: LearningLocaleRoute.page),
    AutoRoute(page: AICredentialsRoute.page),
    AutoRoute(page: PronunciationAssessmentCredentialsRoute.page),
    AutoRoute(page: TTSCredentialsRoute.page),
    AutoRoute(page: HomeRoute.page, initial: true,guards: [_homeGuard]),
    AutoRoute(page: ChatRoute.page,guards: [_chatGuard]),

  ];
}

