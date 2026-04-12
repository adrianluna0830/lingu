import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

class UserAudioMessageDetails extends StatelessWidget {
  final UserAudioMessageDetailsViewDto data;

  const UserAudioMessageDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.rephrasedText != null) ...[
              const Text('Rephrased to Target:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data.rephrasedText!.targetText,
                  style: const TextStyle(fontStyle: FontStyle.italic)),
              const Divider(),
            ],
            Text(
              'Grammar: ${data.grammarFeedback?.correction ?? "Perfect"}\n'
              'Fluency: ${data.fluencyFeedback?.correction ?? "Perfect"}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
