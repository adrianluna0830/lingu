import 'package:lingu/features/chat/ui/chat_messages_list/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/logic/feedback/managers/message_details_manager.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_data.dart';
import 'package:lingu/features/chat/logic/message/managers/chat_messages_manager.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:signals/signals_flutter.dart';

class MessageViewDTOComputed extends Computed<List<MessageViewDTO>> {
  MessageViewDTOComputed(
      {required ChatMessagesManager chatMessagesManager,
      required MessageDetailsManager messageDetailsManager})
      : super(() {
          final messages = chatMessagesManager.messages.value;
          final messageDetails = messageDetailsManager.messageDetails.value;
          List<MessageViewDTO> dtos = [];
          for (var message in messages) {
            final details = messageDetails[message.id];
            if (message is UserTextMessage) {
              final userTextDetails =
                  details is UserTextMessageData ? details : null;
              dtos.add(UserTextMessageViewDTO(
                id: message.id,
                text: message.text,
                correction: userTextDetails?.grammarFeedback?.correction,
                translatedText: userTextDetails?.translatedText,
                grammarErrorSeverity: userTextDetails?.grammarFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
                fluencyCorrection: userTextDetails?.fluencyFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
              ));
            } else if (message is UserAudioMessage) {
              final userAudioDetails =
                  details is UserAudioMessageData ? details : null;
              dtos.add(UserAudioMessageViewDTO(
                id: message.id,
                audioUrl: message.fullMergedAudioFilePath,
                duration: message.duration,
                correction: userAudioDetails?.grammarFeedback?.correction,
                translatedText: userAudioDetails?.translatedText,
                grammarErrorSeverity: userAudioDetails?.grammarFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
                fluencyCorrection: userAudioDetails?.fluencyFeedback != null
                    ? FeedbackResultEnum.none
                    : null,
                pronunciationErrorSeverity:
                    userAudioDetails?.pronunciationFeedback != null
                        ? FeedbackResultEnum.none
                        : null,
              ));
            } else if (message is AITextMessage) {
              final aiTextDetails =
                  details is AITextMessageData ? details : null;
              dtos.add(AITextMessageViewDTO(
                id: message.id,
                text: message.text,
                translation: aiTextDetails?.translation,
              ));
            } else if (message is AIAudioMessage) {
              final aiAudioDetails =
                  details is AIAudioMessageData ? details : null;
              dtos.add(AIAudioMessageViewDTO(
                id: message.id,
                audioUrl: message.audioUrl,
                duration: message.duration,
                transcript: message.audioUrl, // Using audioUrl as placeholder
                translation: aiAudioDetails?.translation,
              ));
            }
          }
          return dtos;
        });
}
