import 'package:flutter/material.dart';

class MessageFeedbackContent extends StatelessWidget {
  final String correction;
  final String explanation;

  const MessageFeedbackContent({
    super.key,
    required this.correction,
    required this.explanation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          correction,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        Text(
          explanation,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}