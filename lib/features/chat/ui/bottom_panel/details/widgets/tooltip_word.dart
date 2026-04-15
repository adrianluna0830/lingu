import 'package:flutter/material.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart' as model;
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/syllable_widget.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TooltipWord extends StatefulWidget {
  final model.WordPronunciationFeedback feedback;

  const TooltipWord({super.key, required this.feedback});

  @override
  State<TooltipWord> createState() => _TooltipWordState();
}

class _TooltipWordState extends State<TooltipWord> {
  final _controller = SuperTooltipController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordColor = getErrorSeverityColor(widget.feedback.detail?.mostSevere);
    final defaultStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 16);

    return SuperTooltip(
            style: const TooltipStyle(
        backgroundColor: Colors.white,
        borderColor: Colors.black,
        borderWidth: 1,
      ),
      controller: _controller,
      content: _buildTooltipContent(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _controller.showTooltip(),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              widget.feedback.word,
              style: defaultStyle.copyWith(color: wordColor),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTooltipContent(BuildContext context) {
    final detail = widget.feedback.detail;
    if (detail == null) return const SizedBox.shrink();

    final syllables = detail.syllableFeedback;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (int i = 0; i < syllables.length; i++) ...[
          SyllableWidget(syllable: syllables[i]),
          if (i < syllables.length - 1) const Text(' '),
        ],
      ],
    );
  }
}
