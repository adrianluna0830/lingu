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
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Text(
          'Translation: ${data.translation ?? "No translation available"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
