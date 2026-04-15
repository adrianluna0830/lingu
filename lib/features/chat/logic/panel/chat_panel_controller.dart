import 'package:lingu/features/chat/logic/message/models/chat_panel_message.dart';

class ChatPanelController
{
  void Function()? onNewChat;
  void Function(List<ChatPanelMessage>)? onNewUserMessage;
  void Function(String question)? onNewQuestion;
  void tryStartNewChatWithQuestion(String question) {
    
      onNewQuestion?.call(question);
    
  }
}
