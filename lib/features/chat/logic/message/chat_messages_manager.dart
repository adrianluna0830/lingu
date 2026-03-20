import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:signals/signals_flutter.dart';

@singleton
class ChatMessagesManager
{

  final _messages = listSignal<ChatMessage>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;

  Future<void> addTextMessage({required String text, required bool isUser}) async
  {
    if(isUser)
    {
      _messages.add(UserTextMessage(text: text));
      
    }
    else
    {
      _messages.add(AITextMessage(text: text));
    }
  }

  Future<void> addAudioMessage({required String audioUrl, required bool isUser, required Duration duration}) async
  {
    if(isUser)
    {
      _messages.add(UserAudioMessage(audioUrl: audioUrl, duration: duration));
    }
    else
    {
      _messages.add(AIAudioMessage(audioUrl: audioUrl, duration: duration));
    }
  }
}
