import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:signals/signals_flutter.dart';

@singleton
class ChatMessagesManager
{

  final _messages = listSignal<ChatMessage>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;

  Future<void> addTextMessage({required String text}) async
  {

      _messages.add(UserTextMessage(text: text));
  

  }

  Future<void> addAudioMessage({required String audioUrl, required Duration duration}) async
  {

      _messages.add(UserAudioMessage(audioUrl: audioUrl, duration: duration));

  }
}
