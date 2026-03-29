import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_correction_level.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_state.dart';
import 'package:lingu/features/chat/logic/message/models/chat_message.dart';
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
  Color _getFeedbackColor(FeedbackCorrectionLevel? level) {
    if (level == null) return Colors.green;
    return level == FeedbackCorrectionLevel.bad ? Colors.red : Colors.orange;
  }

  Widget _buildFeedbackIcons(BuildContext context, ChatMessage chatMessage) {
    if (chatMessage is UserTextMessage) {
      final state = chatMessage.feedbackResult;
      
      return switch (state) {
        FeedbackReady(data: final data) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.spellcheck, size: 16, color: _getFeedbackColor(data.grammar)),
            const SizedBox(width: 4),
            Icon(Icons.auto_fix_high, size: 16, color: _getFeedbackColor(data.fluency)),
          ],
        ),
        FeedbackLoading() => const Text('Analyzing...', style: TextStyle(fontSize: 12, color: Colors.grey)),
        _ => const SizedBox.shrink(),
      };
    } 
    
    if (chatMessage is UserAudioMessage) {
      final state = chatMessage.feedbackResult;
      
      return switch (state) {
        FeedbackReady(data: final data) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.record_voice_over, size: 16, color: _getFeedbackColor(data.pronunciation)),
            const SizedBox(width: 4),
            Icon(Icons.spellcheck, size: 16, color: _getFeedbackColor(data.grammar)),
            const SizedBox(width: 4),
            Icon(Icons.auto_fix_high, size: 16, color: _getFeedbackColor(data.fluency)),
          ],
        ),
        FeedbackLoading() => const Text('Analyzing...', style: TextStyle(fontSize: 12, color: Colors.grey)),
        _ => const SizedBox.shrink(),
      };
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final chatMessage = widget.messages[index];
        final isUserMessage = chatMessage is UserTextMessage || chatMessage is UserAudioMessage;

        final isClickable = switch (chatMessage) {
          UserTextMessage m => m.feedbackResult is FeedbackReady,
          UserAudioMessage m => m.feedbackResult is FeedbackReady,
          AITextMessage _ || AIAudioMessage _ => true,
        };

        Widget content = switch (chatMessage) {
          UserTextMessage m => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(m.text),
            ),
          UserAudioMessage m => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: VoiceNote(
                audioUrl: m.fullMergedAudioUrl,
                duration: m.duration,
              ),
            ),
          AITextMessage m => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Text(m.text),
            ),
          AIAudioMessage m => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
              child: VoiceNote(
                audioUrl: m.audioUrl,
                duration: m.duration,
              ),
            ),
        };

        return Align(
          alignment: isUserMessage 
              ? Alignment.centerRight 
              : Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: isUserMessage 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: GestureDetector(
                  onLongPress: isClickable
                      ? () => widget.controller?.onMessageTap?.call(chatMessage)
                      : null,
                  child: MessageBubble(content: content),
                ),
              ),
              if (isUserMessage)
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 8),
                  child: _buildFeedbackIcons(context, chatMessage),
                ),
            ],
          ),
        );
      },
    );
  }
}

