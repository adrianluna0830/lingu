import 'package:flutter/material.dart';
import 'package:lingu/core/word/word.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:lingu/features/word/word_view_widgets.dart';

class GermanWordView extends StatefulWidget {
  final GermanWord word;
  final WordViewController controller;
  const GermanWordView({super.key, required this.word, required this.controller});

  @override
  State<GermanWordView> createState() => _GermanWordViewState();
}

class _GermanWordViewState extends State<GermanWordView> with SignalsMixin {
  final PageController _pageController = PageController();
  late final _currentPage = createSignal(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            onPageChanged: (index) {
              _currentPage.value = index;
            },
            controller: _pageController,
            itemCount: widget.word.meanings.length,
            itemBuilder: (BuildContext context, int index) {
              final meaning = widget.word.meanings[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlayableSentenceAudio(
                    audioPath: meaning.wordPronunciationAudioPath,
                    sentence: widget.word.word,
                    onChat: () => widget.controller.onChat?.call(widget.word.word),
                    onWordInfo: () => widget.controller.onWordInfo?.call(widget.word.word),
                  ),
                  Text(meaning.partOfSpeech.name, style: const TextStyle(fontStyle: FontStyle.italic)),
                  Text(meaning.meaning),
                  if (meaning.image != null)
                    ImageAndCredits(image: meaning.image!),
                  Text('Gender: ${meaning.languageSpecificDetails.gender}'),
                  Text('Plural Form: ${meaning.languageSpecificDetails.pluralForm}'),
                  Text('Is Separable: ${meaning.languageSpecificDetails.isSeparable}'),
                  Text('Separable Prefix: ${meaning.languageSpecificDetails.separablePrefix}'),
                  Text('Genitive Form: ${meaning.languageSpecificDetails.genitiveForm}'),
                  ...meaning.examples.map(
                    (e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlayableSentenceAudio(
                          audioPath: e.exampleAudioPath,
                          sentence: e.example,
                          onChat: () => widget.controller.onChat?.call(e.example),
                          onWordInfo: () => widget.controller.onWordInfo?.call(e.example),
                        ),
                        Text(e.translation, style: const TextStyle(fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        PageViewDirectionButtons(
          totalPages: widget.word.meanings.length,
          currentPage: _currentPage.watch(context),
          onLeft: () {
            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
          onRight: () {
            _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          },
        ),
      ],
    );
  }
}
