import 'dart:async';


class ChatPanelController
{
  void Function()? onNewChat;
  void Function(String message)? onNewUserMessage;
}
