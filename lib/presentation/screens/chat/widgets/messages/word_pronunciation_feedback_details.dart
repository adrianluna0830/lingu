import 'package:flutter/material.dart';
import 'package:lingu/presentation/ui_utils.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/presentation/screens/chat/components/messages/tooltip_word/word_feedback_controller.dart';
import 'syllable_action_item.dart';

class WordPronunciationFeedbackDetails extends StatelessWidget {
  final WordFeedbackController controller;

  const WordPronunciationFeedbackDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selection = controller.audioSelection.watch(context);
    final feedbackIdx = controller.syllableFeedbackIndex.watch(context);
    final syllablesData = controller.feedback.detail?.syllableFeedback ?? [];

    const double inactiveOpacity = 0.35;
    const double feedbackBoxHeight = 80.0;

    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Usuario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Icon(Icons.person_pin, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.syllables.length > 1) ...[
                          Opacity(
                            opacity: selection is UserWordSelection ? 1.0 : inactiveOpacity,
                            child: SyllableActionItem(text: controller.fullWord, isSelected: selection is UserWordSelection, onTap: () => controller.selectUserWord()),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            for (int i = 0; i < controller.syllables.length; i++)
                              Opacity(
                                opacity: selection is UserSyllableSelection && selection.syllableIndex == i ? 1.0 : inactiveOpacity,
                                child: SyllableActionItem(
                                  text: controller.syllables[i],
                                  isSelected: selection is UserSyllableSelection && selection.syllableIndex == i,
                                  onTap: () => controller.selectUserSyllable(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 12),
              // IA
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Icon(Icons.auto_awesome, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.syllables.length > 1) ...[
                          Opacity(
                            opacity: selection is AIWordSelection ? 1.0 : inactiveOpacity,
                            child: SyllableActionItem(text: controller.fullWord, isSelected: selection is AIWordSelection, onTap: () => controller.selectAIWord()),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            for (int i = 0; i < controller.syllables.length; i++)
                              Opacity(
                                opacity: selection is AISyllableSelection && selection.syllableIndex == i ? 1.0 : inactiveOpacity,
                                child: SyllableActionItem(
                                  text: controller.syllables[i],
                                  isSelected: selection is AISyllableSelection && selection.syllableIndex == i,
                                  onTap: () => controller.selectAISyllable(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (syllablesData.isNotEmpty) ...[
                const Divider(height: 12),
                // Análisis
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2,
                      runSpacing: 2,
                      children: [
                        for (int i = 0; i < syllablesData.length; i++)
                          Opacity(
                            opacity: feedbackIdx?.index == i ? 1.0 : inactiveOpacity,
                            child: SyllableActionItem(
                              text: syllablesData[i].syllable,
                              isSelected: feedbackIdx?.index == i,
                              onTap: syllablesData[i].detail != null ? () => controller.setSyllableFeedbackIndex(i) : null,
                              color: syllablesData[i].detail != null ? getErrorSeverityColor(syllablesData[i].detail?.severity) : Colors.black,
                            ),
                          ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: feedbackBoxHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(6),
                        child: feedbackIdx != null
                            ? Text(
                                feedbackIdx.feedback,
                                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
