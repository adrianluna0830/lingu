import 'package:flutter/material.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart' as model;

class SyllableWidget extends StatelessWidget {
  final model.SyllablePronunciationFeedback syllable;

  const SyllableWidget({super.key, required this.syllable});

  @override
  Widget build(BuildContext context) {
    final color = getErrorSeverityColor(syllable.detail?.severity);
    final defaultStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 14);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            syllable.syllable,
            style: defaultStyle.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}
