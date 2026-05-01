import 'package:flutter/material.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/presentation/widgets/speech_transcription_widget.dart';

class PlayableSentenceAudio extends StatelessWidget {
  final SpeechAudio speechAudio;
  final VoidCallback onWordInfo;
  final VoidCallback onChat;

  const PlayableSentenceAudio({
    super.key,
    required this.speechAudio,
    required this.onWordInfo,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return SpeechTranscriptionWidget(
      speechAudio: speechAudio,
      highlightCurrentSentence: false,
    );
  }
}
