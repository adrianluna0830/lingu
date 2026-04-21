import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/features/word/english_word_view.dart';
import 'package:lingu/features/word/german_word_view.dart';
import 'package:lingu/features/word/spanish_word_view.dart';
import 'package:lingu/core/word/word.dart';

@RoutePage()
class WordView extends StatelessWidget {
  final Word word;

  const WordView({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word View')),
      body: switch (word) {
        EnglishWord w => EnglishWordView(word: w),
        GermanWord w => GermanWordView(word: w),
        SpanishWord w => SpanishWordView(word: w),
      },
    );
  }
}
