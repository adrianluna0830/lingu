import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:lingu/features/word/english_word_view.dart';
import 'package:lingu/features/word/german_word_view.dart';
import 'package:lingu/features/word/spanish_word_view.dart';
import 'package:lingu/core/word/word.dart';
import 'package:lingu/features/word/word_selection_dialog.dart';
import 'package:lingu/features/word/word_view_widgets.dart';

@RoutePage()
class WordView extends StatefulWidget {
  final Word word;

  const WordView({super.key, required this.word});

  @override
  State<WordView> createState() => _WordViewState();
}

class _WordViewState extends State<WordView> {
  late final WordViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WordViewController();
    _controller.onWordInfo = _handleWordInfo;
    _controller.onChat = _handleChat;
  }

  void _handleWordInfo(String sentence) async {
    final result = await showWordSelectionDialog(context, sentence);
    if (result != null && mounted) {
      final localeService = di<LocaleSettingsService>();
      context.router.push(WordFetchRoute(
        word: result.word,
        wordInContext: result.context,
        learningLocale: localeService.learningLocale.value!,
        nativeLocale: localeService.nativeLocale.value!,
      ));
    }
  }

  void _handleChat(String sentence) {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Word View')),
      body: switch (widget.word) {
        EnglishWord w => EnglishWordView(word: w, controller: _controller),
        GermanWord w => GermanWordView(word: w, controller: _controller),
        SpanishWord w => SpanishWordView(word: w, controller: _controller),
      },
    );
  }
}
