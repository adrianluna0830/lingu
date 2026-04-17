import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';
import 'package:lingu/features/chat/ui/widgets/voice_note/voice_note.dart';
import 'package:lingu/features/home/ui/widgets/interactable_text.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AIVoiceMessage extends StatefulWidget {
  final String audioUrl;
  final Duration duration;
  final String transcription;
  final String? translation;
  final VoidCallback onTap;
  final VoidCallback onTranslation;
  final VoidCallback? onWordInfo;
  final VoidCallback? onChat;

  const AIVoiceMessage({
    super.key,
    required this.audioUrl,
    required this.duration,
    required this.transcription,
    this.translation,
    required this.onTap,
    required this.onTranslation,
    this.onWordInfo,
    this.onChat,
  });

  @override
  State<AIVoiceMessage> createState() => _AIVoiceMessageState();
}

class _AIVoiceMessageState extends State<AIVoiceMessage> with SignalsMixin {
  late final _showTranscription = createSignal(false);
  late final _showTranslation = createSignal(false);

  @override
  Widget build(BuildContext context) {
    final isShowingTranscription = _showTranscription.watch(context);
    final isShowingTranslation = _showTranslation.watch(context);

    return MessageLayout(
      isUser: false,
      onLongPress: widget.onTap,
      footerActions: [
        InkWell(
          onTap: () {
            if (isShowingTranslation) {
              _showTranslation.value = false;
            } else {
              _showTranslation.value = true;
              widget.onTranslation();
            }
          },
          borderRadius: BorderRadius.circular(4),
          child: Icon(Icons.translate_rounded, size: 16, color: isShowingTranslation ? Colors.blue : Colors.black38),
        ),
        InkWell(
          onTap: () => _showTranscription.value = !_showTranscription.value,
          borderRadius: BorderRadius.circular(4),
          child: Icon(Icons.subtitles_rounded, size: 16, color: isShowingTranscription ? Colors.blue : Colors.black38),
        ),
      ],
      children: [
        VoiceNoteControls(audioUrl: widget.audioUrl, duration: widget.duration),
        if (isShowingTranslation)
          widget.translation != null
              ? MessageSubText(
                  '"${widget.translation}"',
                  onTap: () => _showTranslation.value = false,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Shimmer(
                    child: Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
        if (isShowingTranscription)
          InteractableText(
            text: '(${widget.transcription})',
            onChat: widget.onChat ?? () {},
            onWordInfo: widget.onWordInfo ?? () {},
            textStyle: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, fontSize: 12),
          ),
      ],
    );
  }
}
