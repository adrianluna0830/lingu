import 'package:flutter/material.dart';
import 'package:just_audio_media_kit/just_audio_media_kit.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_state.dart';
import 'package:lingu/features/chat/logic/message/messages_manager.dart';
import 'package:signals/signals.dart';
import 'package:signals/signals_flutter.dart';
class TextFeedback {
  final MessagesManager _chatMessagesManager;
  TextFeedback(this._chatMessagesManager);

  final _textFeedbacks = mapSignal<int, TextFeedbackState>({});
  ReadonlySignal<Map<int, TextFeedbackState>> get textFeedbacks => _textFeedbacks;


}

class AudioFeedback {
  final MessagesManager _chatMessagesManager;
  AudioFeedback(this._chatMessagesManager);

  final _audioFeedbacks = mapSignal<int, String>({});
  ReadonlySignal<Map<int, String>> get audioFeedbacks => _audioFeedbacks;  
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
