import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

class UserTextMessageDetails extends StatelessWidget {
  final UserTextMessageDetailsViewDto data;

  const UserTextMessageDetails({
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
          'Grammar: ${data.grammarFeedback?.correction ?? "Perfect"}\n'
          'Fluency: ${data.fluencyFeedback?.correction ?? "Perfect"}',
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
