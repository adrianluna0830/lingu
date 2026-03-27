import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/messages_manager.dart';

@injectable
class TextInputHandler {
  final MessagesManager _messagesManager;

  TextInputHandler(
    this._messagesManager,
  );


  Future<void> sendTextMessage({required String text}) async {
    await _messagesManager.addTextMessage(text: text, isUser: true);
  }

}
