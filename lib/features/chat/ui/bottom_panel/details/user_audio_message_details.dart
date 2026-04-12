import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

class UserAudioMessageDetails extends StatelessWidget {
  final UserAudioMessageDetailsViewDto data;

  const UserAudioMessageDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (data.translatedText != null) ...[
            const Text('Translation to Target', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Target: ${data.translatedText!.targetText}'),
            Text('Translation: ${data.translatedText!.translation}'),
            const Divider(),
          ],
          if (data.grammarFeedback != null) ...[
            const Text('Grammar', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Correction: ${data.grammarFeedback!.correction}'),
            Text('Explanation: ${data.grammarFeedback!.explanation}'),
            const Divider(),
          ],
          if (data.fluencyFeedback != null) ...[
            const Text('Fluency', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Correction: ${data.fluencyFeedback!.correction}'),
            Text('Explanation: ${data.fluencyFeedback!.explanation}'),
            const Divider(),
          ],
          if (data.pronunciationFeedback != null) ...[
            const Text('Pronunciation',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Transcript: ${data.pronunciationFeedback!.rawTranscript}'),
            Text('Details: ${data.pronunciationFeedback!.toString()}'),
            const Divider(),
          ],
        ],
      ),
    );
  }
}
