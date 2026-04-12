import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:signals/signals_flutter.dart';

class MessageViewDtoComputed extends Computed<List<MessageViewDto>> {
  MessageViewDtoComputed(
      {required ChatMessagesManager chatMessagesManager,
      required MessageDetailsManager messageDetailsManager})
      : super(() {
          final messages = chatMessagesManager.messages.value;
          final messageDetails = messageDetailsManager.messageDetails.value;
          List<MessageViewDto> dtos = [];
          for (var message in messages) {
            final details = messageDetails[message.id];
            if (message is UserTextMessage) {
              dtos.add(UserTextMessageViewDto(
                chatMessage: message,
                messageDetails: details is UserTextMessageDetailsViewDto ? details : null,
              ));
            } else if (message is UserAudioMessage) {
              dtos.add(UserAudioMessageViewDto(
                chatMessage: message,
                messageDetails: details is UserAudioMessageDetailsViewDto ? details : null,
              ));
            } else if (message is AITextMessage) {
              dtos.add(AITextMessageViewDto(
                chatMessage: message,
                messageDetails: details is AITextMessageDetailsViewDto ? details : null,
              ));
            } else if (message is AIAudioMessage) {
              dtos.add(AIAudioMessageViewDto(
                chatMessage: message,
                messageDetails: details is AIAudioMessageDetailsViewDto ? details : null,
              ));
            }
          }
          return dtos;
        });
}
