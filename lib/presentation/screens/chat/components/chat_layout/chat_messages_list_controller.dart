import 'package:lingu/presentation/screens/chat/models/message_view_dto.dart';

class ChatMessagesListController {
  Function(MessageViewDto)? onWordInfoTap;
  Function(MessageViewDto)? onChatMessageTap;
  Function(MessageViewDto)? onMessageTap;
  Function(MessageViewDto)? onAITranslationTap;
}
