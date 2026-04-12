import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

class AIAudioMessageDetails extends StatelessWidget {
  final AIAudioMessageDetailsViewDto data;

  const AIAudioMessageDetails({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Transcript', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(data.transcript),
          const Divider(),
          const Text('Translation', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(data.translation ?? 'No translation available'),
        ],
      ),
    );
  }
}
