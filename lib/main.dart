import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  JustAudioMediaKit.ensureInitialized();
  await configureDependencies();

  // Reset all required configurations to null for testing
  di<LocaleSettingsService>().nativeLocale.value = null;
  di<LocaleSettingsService>().learningLocale.value = null;
  di<LocaleSettingsService>().currentTargetLanguageCEFR.value = null;
  di<AICredentialsService>().apiKey.value = null;
  di<PronunciationAssessmentCredentialsService>().apiKey.value = null;
  di<TextToSpeechSettingsService>().apiKey.value = null;

  SignalsObserver.instance = null;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: di<AppRouter>().config(),
    );
  }
}

