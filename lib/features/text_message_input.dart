import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/chat_messages_manager.dart';

@singleton
class TextMessageInput
{
  final ChatMessagesManager _messagesManager;
  Function()? onGainFocus;
  TextMessageInput(this._messagesManager);
  void sendTextMessage(String text) {
    _messagesManager.addTextMessage(text: text, isUser: true);
  }

  void gainFocus() {
    if(onGainFocus != null) {
      onGainFocus!();
    }
  }
}