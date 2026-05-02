import 'package:flutter/material.dart';
import 'package:lingu/presentation/widgets/interactive_selectable_text.dart';

class SelectableWords extends StatelessWidget {
  final List<String> words;
  final int? activeIndex;
  final bool highlightSentence;
  final void Function(String word, int index) onTap;
  final void Function(String word)? onChat;
  final void Function(String word)? onWordInfo;

  const SelectableWords({
    super.key,
    required this.words,
    required this.activeIndex,
    this.highlightSentence = false,
    required this.onTap,
    this.onChat,
    this.onWordInfo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = theme.textTheme.bodyMedium;
    final isPlaying = activeIndex != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: (highlightSentence && isPlaying)
          ? BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Wrap(
        spacing: 2.0,
        runSpacing: 4.0,
        children: List.generate(words.length, (index) {
          final isSelected = activeIndex == index;
          final word = words[index];

          return InteractiveSelectableText(
            text: word,
            onChat: () => onChat?.call(word),
            onWordInfo: () => onWordInfo?.call(word),
            onTap: () => onTap(word, index),
            style: effectiveStyle?.copyWith(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        }),
      ),
    );
  }
}
