import 'package:flutter/material.dart';
import 'package:lingu/domain/chat/models/feedback/pronunciation_feedback.dart' as model;
import 'package:lingu/presentation/screens/chat/widgets/feedback/word_pronunciation_feedback.dart';

class AudioPronunciationContent extends StatelessWidget {
  final List<model.PronunciationItemResult> results;
  final String? fluencyFeedback;

  const AudioPronunciationContent({
    super.key,
    required this.results,
    this.fluencyFeedback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WordPronunciationFeedback(results: results),
        const SizedBox(height: 16),
        if (fluencyFeedback != null) ...[
          const Text('Fluency Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(fluencyFeedback!),
        ],
      ],
    );
  }
}
