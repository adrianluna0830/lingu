import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/feedback_correction_level.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/chat_messages_list_controller.dart';
import 'package:lingu/features/chat/ui/message_bubble.dart';
import 'package:lingu/features/chat/ui/voice_note/voice_note.dart';
import 'package:lingu/features/chat/logic/feedback/user_audio_feedback_process.dart';
import 'package:lingu/features/chat/logic/feedback/user_text_feedback_process.dart';
import 'package:signals/signals_flutter.dart';

Color _colorForLevel(FeedbackCorrectionLevel level) {
  return switch (level) {
    FeedbackCorrectionLevel.bad => Colors.red,
    FeedbackCorrectionLevel.neutral => Colors.amber,
  };
}

class TextFeedbackIcons extends StatelessWidget {
  final TextFeedbackResult result;
  const TextFeedbackIcons({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final icons = <Widget>[];

    if (result.feedback != null) {
      icons.add(Icon(
        Icons.record_voice_over,
        color: _colorForLevel(result.feedback!.level),
        size: 18,
      ));
    }

    if (result.grammar != null) {
      icons.add(Icon(
        Icons.spellcheck,
        color: _colorForLevel(result.grammar!.level),
        size: 18,
      ));
    }

    if (icons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: icons,
    );
  }
}

class AudioFeedbackIcons extends StatelessWidget {
  final AudioFeedbackResult result;
  const AudioFeedbackIcons({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final icons = <Widget>[];

    if (result.feedback != null) {
      icons.add(Icon(
        Icons.record_voice_over,
        color: _colorForLevel(result.feedback!.level),
        size: 18,
      ));
    }

    if (result.grammar != null) {
      icons.add(Icon(
        Icons.spellcheck,
        color: _colorForLevel(result.grammar!.level),
        size: 18,
      ));
    }

    if (result.pronunciation != null) {
      icons.add(Icon(
        Icons.mic,
        color: _colorForLevel(result.pronunciation!.level),
        size: 18,
      ));
    }

    if (icons.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: icons,
    );
  }
}

class ChatMessagesList extends StatefulWidget {
  final ChatMessagesListController controller;
  const ChatMessagesList({super.key, required this.controller});

  @override
  State<ChatMessagesList> createState() => _ChatMessagesListState();
}

class _ChatMessagesListState extends State<ChatMessagesList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.controller.messages.watch(context).length,
      itemBuilder: (context, index) {
        final message = widget.controller.messages.watch(context)[index];

        Widget content = switch (message) {
          UserTextMessage textMessage => Text(textMessage.text),
          UserAudioMessage audioMessage => VoiceNote(audioUrl: audioMessage.audioUrl, duration: audioMessage.duration),
          AITextMessage textMessage => Text(textMessage.text),
          AIAudioMessage audioMessage => VoiceNote(audioUrl: audioMessage.audioUrl, duration: audioMessage.duration),
        };

        Widget bubble = MessageBubble(content: content);

        Widget messageWidget = switch (message) {
          UserTextMessage m => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                bubble,
                switch (m.feedbackProcess) {
                  AnalyzingText() => const Text("Analyzing text..."),
                  TextFeedbackResult r => TextFeedbackIcons(result: r),
                },
              ],
            ),
          UserAudioMessage m => Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                bubble,
                switch (m.feedbackProcess) {
                  AnalyzingAudio() => const Text("Analyzing audio..."),
                  GeneratingFeedback() => const Text("Generating feedback..."),
                  AudioFeedbackResult r => AudioFeedbackIcons(result: r),
                },
              ],
            ),
          AITextMessage() || AIAudioMessage() => bubble,
        };

        return Align(
          alignment: switch (message) {
            UserTextMessage() => Alignment.centerRight,
            UserAudioMessage() => Alignment.centerRight,
            AITextMessage() => Alignment.centerLeft,
            AIAudioMessage() => Alignment.centerLeft,
          },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: messageWidget,
          ),
        );
      },
    );
  }
}