import 'package:flutter/material.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/presentation/widgets/speech_transcription_widget.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/presentation/screens/chat/widgets/messages/message_layout.dart';
import 'package:lingu/presentation/screens/chat/components/input/voice_note_controls.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AIVoiceMessage extends StatefulWidget {
  final String transcription;
  final String? translation;
  final SpeechAudio speechAudio;
  final VoidCallback onTap;
  final VoidCallback onTranslation;
  final VoidCallback? onWordInfo;
  final VoidCallback? onChat;

  const AIVoiceMessage({
    super.key,
    required this.transcription,
    required this.speechAudio,
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
  late final _showTranslation = createSignal(false);
  late final _showTranscription = createSignal(false);

  @override
  Widget build(BuildContext context) {
    final isShowingTranslation = _showTranslation.watch(context);
    final isShowingTranscription = _showTranscription.watch(context);

    return MessageLayout(
      isUser: false,
      onLongPress: widget.onTap,
      footerActions: [
        InkWell(
          onTap: () => _showTranscription.value = !_showTranscription.value,
          borderRadius: BorderRadius.circular(4),
          child: Icon(
            isShowingTranscription
                ? Icons.description_rounded
                : Icons.description_outlined,
            size: 16,
            color: isShowingTranscription ? Colors.blue : Colors.black38,
          ),
        ),
        const SizedBox(width: 8),
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
          child: Icon(Icons.translate_rounded,
              size: 16,
              color: isShowingTranslation ? Colors.blue : Colors.black38),
        ),
      ],
      children: [
        VoiceNoteControls(
          audioUrl: widget.speechAudio.audioUrl,
          duration: widget.speechAudio.duration,
        ),
        if (isShowingTranscription)
          SpeechTranscriptionWidget(
            speechAudio: widget.speechAudio,
            highlightCurrentSentence: false,
            onChat: (_) => widget.onChat?.call(),
            onWordInfo: (_) => widget.onWordInfo?.call(),
          ),
        if (isShowingTranslation)
          widget.translation != null && widget.translation!.trim().isNotEmpty
              ? MessageSubText(
                  '"${widget.translation}"',
                  onTap: () => _showTranslation.value = false,
                )
              : widget.translation == null || widget.translation!.isEmpty
                  ? Padding(
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
                    )
                  : const SizedBox.shrink(),
      ],
    );
  }
}
