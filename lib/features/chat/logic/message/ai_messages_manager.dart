import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/features/chat/logic/message/messages_manager.dart';
import 'package:lingu/features/chat/logic/message/text_input_handler.dart';

@Singleton(scope: 'chat')
class AIMessagesManager {
  final MessagesManager _chatMessagesManager;
  final TextInputHandler _userMessagesHandler;
  final ITextToSpeechService _textToSpeechService;
  final IAudioPlayerManager _audioPlayerManager;
  final IAIModel _aiModel;

  AIMessagesManager(
    this._chatMessagesManager,
    this._userMessagesHandler,
    this._textToSpeechService,
    this._audioPlayerManager,
    this._aiModel,
  ) {
  }



  Future<void> sendMessage() async {}
}
