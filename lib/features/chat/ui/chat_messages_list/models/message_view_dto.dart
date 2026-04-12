import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';

sealed class MessageViewDto {
  final int id;
  MessageViewDto({required this.id});
}

class UserTextMessageViewDto extends MessageViewDto {
  final UserTextMessage chatMessage;
  final UserTextMessageDetailsViewDto? messageDetails;

  UserTextMessageViewDto({
    required this.chatMessage,
    required this.messageDetails,
  }) : super(id: chatMessage.id);
}

class UserAudioMessageViewDto extends MessageViewDto {
  final UserAudioMessage chatMessage;
  final UserAudioMessageDetailsViewDto? messageDetails;

  UserAudioMessageViewDto({
    required this.chatMessage,
    required this.messageDetails,
  }) : super(id: chatMessage.id);
}

class AITextMessageViewDto extends MessageViewDto {
  final AITextMessage chatMessage;
  final AITextMessageDetailsViewDto? messageDetails;

  AITextMessageViewDto({
    required this.chatMessage,
    required this.messageDetails,
  }) : super(id: chatMessage.id);
}

class AIAudioMessageViewDto extends MessageViewDto {
  final AIAudioMessage chatMessage;
  final AIAudioMessageDetailsViewDto? messageDetails;

  AIAudioMessageViewDto({
    required this.chatMessage,
    required this.messageDetails,
  }) : super(id: chatMessage.id);
}
