
enum ChatRole { user, model }

sealed class AIChatMessage  {
  final String text;
  final ChatRole role;
  final DateTime createdAt;

  const AIChatMessage({
    required this.text,
    required this.role,
    required this.createdAt,
  });
}

class UserMessage extends AIChatMessage  {
  const UserMessage({
    required super.text,
    required super.createdAt,
  }) : super(role: ChatRole.user);
}

class ModelMessage extends AIChatMessage  {
  const ModelMessage({
    required super.text,
    required super.createdAt,
  }) : super(role: ChatRole.model);
}