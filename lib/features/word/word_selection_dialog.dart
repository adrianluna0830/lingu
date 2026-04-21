import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

Future<({String word, String context})?> showWordSelectionDialog(
  BuildContext context,
  String content,
) async {
  final words = content.trim().split(RegExp(r'\s+'));
  final selectedIndex = signal<int?>(null);

  return showDialog<({String word, String context})>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Select a word'),
      content: SingleChildScrollView(
        child: Watch((context) {
          final currentIdx = selectedIndex.value;
          final theme = Theme.of(context);

          return Wrap(
            spacing: 2.0,
            runSpacing: 2.0,
            alignment: WrapAlignment.center,
            children: List.generate(words.length, (index) {
              final isSelected = currentIdx == index;
              final word = words[index];

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    selectedIndex.value = index;
                  },
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          word,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.transparent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          word,
                          style: theme.textTheme.titleLarge?.copyWith(
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
        }),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
        Watch((context) {
          final currentIdx = selectedIndex.value;
          return ElevatedButton(
            onPressed: currentIdx == null
                ? null
                : () {
                    final selectedWord = words[currentIdx];
                    final cleanWord = selectedWord.replaceAll(RegExp(r'[^\w\s]'), '');

                    final List<String> highlightedWords = List.from(words);
                    highlightedWords[currentIdx] = '**${words[currentIdx]}**';
                    final highlightedContext = highlightedWords.join(' ');

                    Navigator.pop(ctx, (word: cleanWord, context: highlightedContext));
                  },
            child: const Text('Select'),
          );
        }),
      ],
    ),
  );
}
