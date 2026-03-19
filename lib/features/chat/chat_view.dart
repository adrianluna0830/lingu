import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/features/chat/record/record_controller.dart';
import 'package:lingu/features/chat/record/record_display.dart';

@RoutePage()
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat View')),
    
    );
  }
}
