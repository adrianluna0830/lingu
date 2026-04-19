import 'package:lingu/core/ai/core/ai_chat_message.dart';

class AIChatHistory {
  final List<AIChatMessage> messages;

  const AIChatHistory([this.messages = const []]);

  AIChatHistory _add(AIChatMessage message) => AIChatHistory([
        ...messages,
        message,
      ]);

  AIChatHistory addUser(String text) => _add(UserMessage(text: text));

  AIChatHistory addModel(String text) => _add(ModelMessage(text: text));

  AIChatHistory addModelAudio({
    required String text,
    required String audioUrl,
    required Duration duration,
  }) =>
      _add(ModelMessage(
        text: text,
        audioUrl: audioUrl,
        duration: duration,
      ));

  bool get isEmpty => messages.isEmpty;
  int get length => messages.length;
}
