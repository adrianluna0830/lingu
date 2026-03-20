
import 'package:lingu/core/ai/core/ai_chat_message.dart';


class AIChatHistory  {
  final List<AIChatMessage> messages;

  const AIChatHistory([this.messages = const []]);

  AIChatHistory addUser(String text) => AIChatHistory([
        ...messages,
        UserMessage(text: text, createdAt: DateTime.now()),
      ]);

  AIChatHistory addModel(String text) => AIChatHistory([
        ...messages,
        ModelMessage(text: text, createdAt: DateTime.now()),
      ]);




  bool get isEmpty => messages.isEmpty;
  int get length => messages.length;
}