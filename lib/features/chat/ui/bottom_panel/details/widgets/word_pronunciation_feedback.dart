import 'package:flutter/material.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart' as model;
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/tooltip_word.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/user_audio_message_details.dart';

class WordPronunciationFeedback extends StatelessWidget {
  final List<model.PronunciationItemResult> results;

  const WordPronunciationFeedback({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> words = [];
    final defaultStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 16);

    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      final isLastResult = i == results.length - 1;

      if (result is model.TargetLanguagePronunciationResult) {
        for (int j = 0; j < result.wordFeedback.length; j++) {
          final wordObj = result.wordFeedback[j];
          final isLastWord = j == result.wordFeedback.length - 1;

          final wordColor = getErrorSeverityColor(wordObj.detail?.mostSevere);
          final hasError = wordColor != null;

          if (hasError) {
            words.add(
              TooltipWord(
                feedback: wordObj,
              ),
            );
          } else {
            words.add(
              Text(
                wordObj.word,
                style: defaultStyle,
              ),
            );
          }

          if (!(isLastWord && isLastResult)) {
            words.add(Text(' ', style: defaultStyle));
          }
        }
      } else {
        words.add(
          Text(
            result.transcript + (isLastResult ? '' : ' '),
            style: defaultStyle,
          ),
        );
      }
    }

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: words,
    );
  }
}
