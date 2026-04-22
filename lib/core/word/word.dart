import 'package:lingu/core/word/word_details/english_word_details.dart';
import 'package:lingu/core/word/word_details/german_word_details.dart';
import 'package:lingu/core/word/word_details/spanish_word_details.dart';

sealed class Word {
  final String word;
  final List<WordMeaning> meanings;

  Word({required this.word, required this.meanings});
}

enum PartOfSpeech {
  noun,
  verb,
  adjective,
  adverb,
  pronoun,
  preposition,
  conjunction,
  interjection,
}

final class WordImage {
  final String imagePath;
  final String imageCredits;
  final int width;
  final int height;

  WordImage({required this.imagePath, required this.imageCredits, required this.width, required this.height});

  factory WordImage.fromJson(Map<String, dynamic> json) {
    return WordImage(
      imagePath: json['imagePath'] as String,
      imageCredits: json['imageCredits'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'imageCredits': imageCredits,
        'width': width,
        'height': height,
      };
}

final class WordMeaning {
  final String meaning;
  final PartOfSpeech partOfSpeech;
  final List<WordExample> examples;
  final String wordPronunciationAudioPath;
  final WordImage? image;
  final dynamic languageSpecificDetails;

  WordMeaning({
    required this.meaning,
    required this.partOfSpeech,
    required this.examples,
    required this.wordPronunciationAudioPath,
    this.image,
    required this.languageSpecificDetails,
  });

  factory WordMeaning.fromJson(
    Map<String, dynamic> json,
    dynamic Function(Map<String, dynamic>) detailsFromJson,
  ) {
    return WordMeaning(
      meaning: json['meaning'] as String,
      partOfSpeech: PartOfSpeech.values.byName(json['partOfSpeech'] as String),
      examples: (json['examples'] as List)
          .map((e) => WordExample.fromJson(e as Map<String, dynamic>))
          .toList(),
      wordPronunciationAudioPath: json['wordPronunciationAudioPath'] as String,
      image: json['image'] != null
          ? WordImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      languageSpecificDetails: detailsFromJson(
          json['languageSpecificDetails'] as Map<String, dynamic>),
    );
  }
}

final class WordExample {
  final String translation;
  final String example;
  final String exampleAudioPath;

  WordExample({
    required this.translation,
    required this.example,
    required this.exampleAudioPath,
  });

  factory WordExample.fromJson(Map<String, dynamic> json) {
    return WordExample(
      translation: json['translation'] as String,
      example: json['example'] as String,
      exampleAudioPath: json['exampleAudioPath'] as String,
    );
  }
}

class GermanWord extends Word {
  GermanWord({required super.word, required super.meanings});

  factory GermanWord.fromJson(Map<String, dynamic> json) {
    return GermanWord(
      word: json['word'] as String,
      meanings: (json['meanings'] as List)
          .map((m) => WordMeaning.fromJson(
                m as Map<String, dynamic>,
                GermanWordDetails.fromJson,
              ))
          .toList(),
    );
  }
}

class EnglishWord extends Word {
  EnglishWord({required super.word, required super.meanings});

  factory EnglishWord.fromJson(Map<String, dynamic> json) {
    return EnglishWord(
      word: json['word'] as String,
      meanings: (json['meanings'] as List)
          .map((m) => WordMeaning.fromJson(
                m as Map<String, dynamic>,
                EnglishWordDetails.fromJson,
              ))
          .toList(),
    );
  }
}

class SpanishWord extends Word {
  SpanishWord({required super.word, required super.meanings});

  factory SpanishWord.fromJson(Map<String, dynamic> json) {
    return SpanishWord(
      word: json['word'] as String,
      meanings: (json['meanings'] as List)
          .map((m) => WordMeaning.fromJson(
                m as Map<String, dynamic>,
                SpanishWordDetails.fromJson,
              ))
          .toList(),
    );
  }
}
