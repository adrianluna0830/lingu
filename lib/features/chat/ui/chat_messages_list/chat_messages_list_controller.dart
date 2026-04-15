import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';

class ChatMessagesListController {
  Function(MessageViewDto)? onWordInfoTap;
  Function(MessageViewDto)? onChatMessageTap;
  Function(MessageViewDto)? onMessageTap;
  Function(MessageViewDto)? onAITranslationTap;
}
