import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/models/message_view_dto.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/user_text_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/user_voice_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/ai_text_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/ai_voice_message.dart';

class ChatMessagesList extends StatelessWidget {
  final List<MessageViewDto> messages;
  final ChatMessagesListController? controller;

  const ChatMessagesList({super.key, required this.messages, this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        Widget child = switch (message) {
          UserTextMessageViewDto message => UserTextMessage(
            text: message.chatMessage.text,
            feedbackResult: message.feedbackSummary?.result,
            translation: message.feedbackSummary?.translation,
            onTap: () => controller?.onMessageTap?.call(message),
          ),
          UserAudioMessageViewDto message => UserVoiceMessage(
            audioUrl: message.chatMessage.fullMergedAudioFilePath,
            duration: message.chatMessage.duration,
            feedbackResult: message.feedbackSummary?.result,
            translation: message.feedbackSummary?.translation,
            transcription: message.feedbackSummary?.transcription,
            onTap: () => controller?.onMessageTap?.call(message),
          ),
          AITextMessageViewDto message => AITextMessage(
            text: message.chatMessage.text,
            translation: message.translation,
            onTap: () => controller?.onMessageTap?.call(message),
            onTranslation: () => controller?.onAITranslationTap?.call(message),
          ),
          AIAudioMessageViewDto message => AIVoiceMessage(
            audioUrl: message.chatMessage.audioUrl,
            duration: message.chatMessage.duration,
            transcription: message.chatMessage.transcription,
            translation: message.translation,
            onTap: () => controller?.onMessageTap?.call(message),
            onTranslation: () => controller?.onAITranslationTap?.call(message),
          ),
        };

        return Padding(padding: const EdgeInsets.only(right: 7, left: 7, top: 3, bottom: 6), child: child);
      },
    );
  }
}
