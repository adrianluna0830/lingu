sealed class Message
{
  final bool isUser;
  final int id;
  Message({required this.isUser, required this.id});

}

class TextMessage extends Message
{
  final String text;
  TextMessage({required this.text, required super.isUser, required super.id});
}

class AudioMessage extends Message
{
  final String audioUrl;
  AudioMessage({required this.audioUrl, required super.isUser, required super.id});
}