class Message
{
  final int id;
  final bool isUserMessage;
  final MessageContent content;

  Message({
    required this.id,
    required this.isUserMessage,
    required this.content,
  });
}

sealed class MessageContent {

}

class TextMessage extends MessageContent {
  final String text;

  TextMessage(this.text);
}

class AudioMessage extends MessageContent {
  final String audioUrl;
  final Duration duration;

  AudioMessage(this.audioUrl, this.duration);
}

