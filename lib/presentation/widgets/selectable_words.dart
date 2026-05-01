import 'package:flutter/material.dart';

class SelectableWords extends StatelessWidget {
  final List<String> words;
  final int? activeIndex;
  final bool highlightSentence;
  final void Function(String word, int index) onTap;

  const SelectableWords({
    super.key,
    required this.words,
    required this.activeIndex,
    this.highlightSentence = false,
    required this.onTap,
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

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onTap(word, index),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: Text(
                  word,
                  style: effectiveStyle?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
