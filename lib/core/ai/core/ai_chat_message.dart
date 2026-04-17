
enum ChatRole { user, model }

sealed class AIChatMessage  {
  final String text;
  final ChatRole role;

  const AIChatMessage({
    required this.text,
    required this.role,
  });
}

class UserMessage extends AIChatMessage  {
  const UserMessage({
    required super.text,
  }) : super(role: ChatRole.user);
}

class ModelMessage extends AIChatMessage  {
  const ModelMessage({
    required super.text,
  }) : super(role: ChatRole.model);
}