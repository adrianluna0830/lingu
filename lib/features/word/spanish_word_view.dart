import 'package:flutter/material.dart';
import 'package:lingu/core/word/word.dart';

class SpanishWordView extends StatelessWidget {
  final SpanishWord word;
  const SpanishWordView({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Word: ${word.word}'),
        ...word.meanings.map((m) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Meaning: ${m.meaning}'),
                Text('Part of Speech: ${m.partOfSpeech}'),
                Text('Audio Path: ${m.wordPronunciationAudioPath}'),
                Text('Image Path: ${m.imagePath}'),
                Text('Gender: ${m.languageSpecificDetails.gender}'),
                Text('Plural Form: ${m.languageSpecificDetails.pluralForm}'),
                Text('Is Reflexive: ${m.languageSpecificDetails.isReflexive}'),
                Text('Verb Type: ${m.languageSpecificDetails.verbType}'),
                ...m.examples.map((e) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Example: ${e.example}'),
                        Text('Translation: ${e.translation}'),
                        Text('Example Audio: ${e.exampleAudioPath}'),
                      ],
                    )),
              ],
            )),
      ],
    );
  }
}
