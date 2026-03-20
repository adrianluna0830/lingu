sealed class RawMessage
{
  final bool isUser;
  final int id;
  RawMessage({required this.isUser, required this.id});

}

class RawTextMessage extends RawMessage
{
  final String text;
  RawTextMessage({required this.text, required super.isUser, required super.id});
}

class RawAudioMessage extends RawMessage
{
  final String audioUrl;
  final Duration duration;

  RawAudioMessage({required super.isUser, required super.id, required this.audioUrl, required this.duration});

}