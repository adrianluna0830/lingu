import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/hive/hive_registrar.g.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();
  JustAudioMediaKit.ensureInitialized();
  await configureDependencies();

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

