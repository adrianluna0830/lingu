import 'package:flutter/material.dart';

class SelectableWords extends StatelessWidget {
  final List<String> words;
  final int? activeIndex;
  final void Function(String word, int index) onTap;

  const SelectableWords({
    super.key,
    required this.words,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveStyle = theme.textTheme.titleLarge;

    return Wrap(
      spacing: 2.0,
      runSpacing: 4.0,
      alignment: WrapAlignment.center,
      children: List.generate(words.length, (index) {
        final isSelected = activeIndex == index;
        final word = words[index];

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(word, index),
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    word,
                    style: effectiveStyle?.copyWith(
                      color: Colors.transparent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    word,
                    style: effectiveStyle?.copyWith(
                      color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
