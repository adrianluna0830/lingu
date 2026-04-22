import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/word/word_view_widgets.dart';

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

          return SelectableWords(
            words: words,
            activeIndex: currentIdx,
            onTap: (word, index) {
              selectedIndex.value = index;
            },
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
