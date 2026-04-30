import 'package:flutter/material.dart';
import 'package:lingu/presentation/ui_utils.dart';
import 'package:lingu/domain/chat/models/feedback/pronunciation_feedback.dart' as model;
import 'package:super_tooltip/super_tooltip.dart';
import 'package:lingu/presentation/screens/chat/widgets/messages/word_pronunciation_feedback_details.dart';
import 'word_feedback_controller.dart';

class TooltipWord extends StatefulWidget {
  final model.WordPronunciationFeedback feedback;

  const TooltipWord({super.key, required this.feedback});

  @override
  State<TooltipWord> createState() => _TooltipWordState();
}

class _TooltipWordState extends State<TooltipWord> {
  final _tooltipController = SuperTooltipController();
  late final _feedbackController = WordFeedbackController(widget.feedback);

  @override
  void dispose() {
    _tooltipController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordColor = getErrorSeverityColor(widget.feedback.detail?.mostSevere);
    final defaultStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 16);

    return SuperTooltip(
      style: const TooltipStyle(backgroundColor: Colors.white, borderColor: Colors.black, borderWidth: 1),
      positionConfig: const PositionConfiguration(preferredDirection: TooltipDirection.down),
      controller: _tooltipController,
      content: WordPronunciationFeedbackDetails(controller: _feedbackController),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _tooltipController.showTooltip(),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(widget.feedback.word, style: defaultStyle.copyWith(color: wordColor)),
          ),
        ),
      ),
    );
  }
}

class WordFeedbackTooltip extends StatefulWidget {
  final model.WordPronunciationFeedback feedback;

  const WordFeedbackTooltip({super.key, required this.feedback});

  @override
  State<WordFeedbackTooltip> createState() => _WordFeedbackTooltipState();
}

class _WordFeedbackTooltipState extends State<WordFeedbackTooltip> {
  late final WordFeedbackController _controller = WordFeedbackController(widget.feedback);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WordPronunciationFeedbackDetails(controller: _controller);
  }
}
