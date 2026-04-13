import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';
import 'package:lingu/features/chat/ui/widgets/voice_note/voice_note.dart';

class AIVoiceMessage extends StatefulWidget {
  final String audioUrl;
  final Duration duration;
  final String transcription;
  final String? translation;
  final VoidCallback onTap;
  final VoidCallback onTranslation;

  const AIVoiceMessage({super.key, required this.audioUrl, required this.duration, required this.transcription, this.translation, required this.onTap, required this.onTranslation});

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
      alignment: Alignment.centerLeft,
      onLongPress: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0, top: 8.0, bottom: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            VoiceNoteControls(audioUrl: widget.audioUrl, duration: widget.duration),
            const SizedBox(height: 6),

            if (isShowingTranslation)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: InkWell(
                  onTap: () => _showTranslation.value = false,
                  borderRadius: BorderRadius.circular(4),
                  child: Text(
                    widget.translation != null ? '"${widget.translation}"' : '"Cargando..."',
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, fontSize: 12),
                  ),
                ),
              ),

            if (isShowingTranscription)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: InkWell(
                  onTap: () => _showTranscription.value = false,
                  borderRadius: BorderRadius.circular(4),
                  child: Text(
                    '(${widget.transcription})',
                    style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, fontSize: 12),
                  ),
                ),
              ),

            if (!isShowingTranslation || !isShowingTranscription)
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 4.0, top: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isShowingTranslation)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: InkWell(
                          onTap: () {
                            _showTranslation.value = true;
                            widget.onTranslation();
                          },
                          borderRadius: BorderRadius.circular(4),
                          child: const Icon(Icons.translate_rounded, size: 16, color: Colors.black38),
                        ),
                      ),
                    if (!isShowingTranscription)
                      InkWell(
                        onTap: () => _showTranscription.value = true,
                        borderRadius: BorderRadius.circular(4),
                        child: const Icon(Icons.subtitles_rounded, size: 16, color: Colors.black38),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
