
enum ChatRole { user, model }

sealed class AIChatMessage {
  final String text;
  final ChatRole role;
  final String? audioUrl;
  final Duration? duration;

  const AIChatMessage({
    required this.text,
    required this.role,
    this.audioUrl,
    this.duration,
  });
}

class UserMessage extends AIChatMessage {
  const UserMessage({
    required super.text,
  }) : super(role: ChatRole.user);
}

class ModelMessage extends AIChatMessage {
  const ModelMessage({
    required super.text,
    super.audioUrl,
    super.duration,
  }) : super(role: ChatRole.model);
}