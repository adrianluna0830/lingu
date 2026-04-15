import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/router/guards/chat_guard.dart';
import 'package:lingu/core/router/guards/home_guard.dart';
import 'package:lingu/core/router/guards/login_guards.dart';
import 'package:lingu/features/chat/ui/chat_view.dart';
import 'package:lingu/features/home/ui/home_view.dart';
import 'package:lingu/features/home/ui/main_view.dart';
import 'package:lingu/features/settings/ui/settings_view.dart';
import 'package:lingu/features/login/ui/ai_credentials_view.dart';
import 'package:lingu/features/login/ui/stt_credentials_view.dart';
import 'package:lingu/features/login/ui/learning_locale_view.dart';
import 'package:lingu/features/login/ui/cefr_level_view.dart';
import 'package:lingu/features/login/ui/native_locale_view.dart';
import 'package:lingu/features/login/ui/pronunciation_assessment_credentials_view.dart';
import 'package:lingu/features/login/ui/tts_credentials_view.dart';
import 'package:lingu/features/topics/topics_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  final NativeLocaleGuard _nativeLocaleGuard;
  final LearningLocaleGuard _learningLocaleGuard;
  final CEFRLevelGuard _cefrLevelGuard;
  final AICredentialsGuard _aiCredentialsGuard;
  final STTCredentialsGuard _sttCredentialsGuard;
  final PronunciationAssessmentCredentialsGuard _pronunciationAssessmentCredentialGuard;
  final TTSCredentialsGuard _ttsCredentialsGuard;
  final ChatGuard _chatGuard;
  final HomeGuard _homeGuard;

  AppRouter(
    this._nativeLocaleGuard,
    this._learningLocaleGuard,
    this._cefrLevelGuard,
    this._aiCredentialsGuard,
    this._sttCredentialsGuard,
    this._pronunciationAssessmentCredentialGuard,
    this._ttsCredentialsGuard,
    this._chatGuard,
    this._homeGuard,
  );

  @override
  List<AutoRouteGuard> get guards => [
    _nativeLocaleGuard,
    _learningLocaleGuard,
    _cefrLevelGuard,
    _aiCredentialsGuard,
    _sttCredentialsGuard,
    _pronunciationAssessmentCredentialGuard,
    _ttsCredentialsGuard,
  ];
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: NativeLocaleRoute.page),
    AutoRoute(page: TopicsRoute.page),
    AutoRoute(page: LearningLocaleRoute.page),
    AutoRoute(page: CEFRLevelRoute.page),
    AutoRoute(page: AICredentialsRoute.page),
    AutoRoute(page: STTCredentialsRoute.page),
    AutoRoute(page: PronunciationAssessmentCredentialsRoute.page),
    AutoRoute(page: TTSCredentialsRoute.page),
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