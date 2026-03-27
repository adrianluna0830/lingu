import 'package:flutter/material.dart' hide Feedback;
import 'package:lingu/features/chat/logic/feedback/models/audio_feedback_state.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';
import 'package:lingu/features/chat/logic/feedback/models/text_feedback_state.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:lingu/features/chat/logic/message/message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/message_bubble.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note.dart';

class ChatMessagesList extends StatefulWidget {
  final List<ChatMessage> messages;
  final ChatMessagesListController? controller;

  const ChatMessagesList({
    super.key,
    required this.messages,
    this.controller,
  });

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  Color _getFeedbackColor(Feedback? feedback) {
    if (feedback == null) return Colors.green;
    return feedback.level == FeedbackCorrectionLevel.bad 
        ? Colors.red 
        : Colors.orange;
  }

  Color _getPronunciationColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildFeedbackIcons(ChatMessage chatMessage) {
    if (chatMessage is UserTextMessage) {
      final state = chatMessage.feedbackState;
      if (state is! TextFeedbackResult) return const SizedBox.shrink();
      
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.spellcheck, size: 16, color: _getFeedbackColor(state.grammar)),
          const SizedBox(width: 4),
          Icon(Icons.auto_fix_high, size: 16, color: _getFeedbackColor(state.fluency)),
        ],
      );
    } 
    
    if (chatMessage is UserAudioMessage) {
      final state = chatMessage.feedbackState;
      if (state is! AudioFeedbackResult) return const SizedBox.shrink();

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.record_voice_over, size: 16, color: _getPronunciationColor(state.pronunciation.pronScore)),
          const SizedBox(width: 4),
          Icon(Icons.spellcheck, size: 16, color: _getFeedbackColor(state.grammar)),
          const SizedBox(width: 4),
          Icon(Icons.auto_fix_high, size: 16, color: _getFeedbackColor(state.fluency)),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final chatMessage = widget.messages[index];
        final message = chatMessage.message;

        Widget content = switch (chatMessage) {
          UserTextMessage m => Text((m.message.content as TextMessage).text),
          UserAudioMessage m => VoiceNote(
              audioUrl: (m.message.content as AudioMessage).audioUrl,
              duration: (m.message.content as AudioMessage).duration,
            ),
          AITextMessage m => Text((m.message.content as TextMessage).text),
          AIAudioMessage m => VoiceNote(
              audioUrl: (m.message.content as AudioMessage).audioUrl,
              duration: (m.message.content as AudioMessage).duration,
            ),
        };

        return Align(
          alignment: message.isUserMessage 
              ? Alignment.centerRight 
              : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: message.isUserMessage 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: GestureDetector(
                  onTap: () => widget.controller?.onMessageTap?.call(chatMessage),
                  child: MessageBubble(content: content),
                ),
              ),
              if (message.isUserMessage)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: _buildFeedbackIcons(chatMessage),
                ),
            ],
          ),
        );
      },
    );
  }
}
