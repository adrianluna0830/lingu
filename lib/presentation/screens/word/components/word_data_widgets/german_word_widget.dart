import 'package:flutter/material.dart';
import 'package:lingu/presentation/screens/word/widgets/image_and_credits.dart';
import 'package:lingu/presentation/screens/word/widgets/page_view_direction_buttons.dart';
import 'package:lingu/presentation/screens/word/components/playable_sentence_audio/playable_sentence_audio.dart';
import 'package:lingu/presentation/screens/word/components/word_data_widgets/word_view_controller.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:signals_flutter/signals_flutter.dart';

class GermanWordWidget extends StatefulWidget {
  final GermanWord word;
  final WordViewController controller;
  const GermanWordWidget({super.key, required this.word, required this.controller});

  @override
  State<GermanWordWidget> createState() => _GermanWordWidgetState();
}

class _GermanWordWidgetState extends State<GermanWordWidget> with SignalsMixin {
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
                    speechAudio: meaning.speechAudio,
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
                           speechAudio: e.speechAudio,
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
