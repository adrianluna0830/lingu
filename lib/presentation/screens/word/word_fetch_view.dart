import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:lingu/domain/word/managers/i_word_manager.dart';
import 'package:lingu/domain/word/models/word.dart';
@RoutePage()
class WordFetchView extends StatefulWidget {
  final String word;
  final String wordInContext;
  final LanguageLocale learningLocale;
  final LanguageLocale nativeLocale;

  const WordFetchView({
    super.key,
    required this.word,
    required this.wordInContext,
    required this.learningLocale,
    required this.nativeLocale,
  });

  @override
  State<WordFetchView> createState() => _WordFetchViewState();
}

class _WordFetchViewState extends State<WordFetchView> {
  late final IWordManager<Word, dynamic> _wordManager;

  @override
  void initState() {
    super.initState();
    _wordManager = di<IWordManager<Word, dynamic>>(
      param1: widget.learningLocale,
    );
    _initFetch();
  }

  Future<void> _initFetch() async {
    try {
      final wordObj = await _wordManager.fetchWord(
        widget.word,
        wordInContext: widget.wordInContext,
        nativeLocale: widget.nativeLocale,
      );
      if (mounted) {
        context.router.replace(WordRoute(word: wordObj));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching word: $e')),
        );
        context.router.back();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
