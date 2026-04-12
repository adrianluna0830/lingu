import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

class AITextMessageDetails extends StatelessWidget {
  final AITextMessageDetailsViewDto data;

  const AITextMessageDetails({
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
          const Text('Translation', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(data.translation ?? 'No translation available'),
        ],
      ),
    );
  }
}
