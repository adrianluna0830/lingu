import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_data.dart';

class AIAudioMessageDetails extends StatelessWidget {
  final AIAudioMessageData data;

  const AIAudioMessageDetails({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Text(
          'Transcript: ${data.transcript}\n'
          'Translation: ${data.translation ?? "No translation available"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
