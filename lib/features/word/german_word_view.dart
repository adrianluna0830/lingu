import 'package:flutter/material.dart';
import 'package:lingu/core/word/word.dart';

class GermanWordView extends StatelessWidget {
  final GermanWord word;
  const GermanWordView({super.key, required this.word});

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
                Text('Is Separable: ${m.languageSpecificDetails.isSeparable}'),
                Text('Separable Prefix: ${m.languageSpecificDetails.separablePrefix}'),
                Text('Genitive Form: ${m.languageSpecificDetails.genitiveForm}'),
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
