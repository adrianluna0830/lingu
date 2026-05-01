import 'package:lingu/domain/word/models/details/english_word_details.dart';
import 'package:lingu/domain/word/models/details/german_word_details.dart';
import 'package:lingu/domain/word/models/details/spanish_word_details.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';

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
  final WordImage? image;
  final dynamic languageSpecificDetails;
  final SpeechAudio speechAudio;

  WordMeaning({
    required this.meaning,
    required this.partOfSpeech,
    required this.examples,
    this.image,
    required this.languageSpecificDetails,
    required this.speechAudio,
  });
}

final class WordExample {
  final String translation;
  final String example;
  final SpeechAudio speechAudio;

  WordExample({
    required this.translation,
    required this.example,
    required this.speechAudio,
  });
}

class GermanWord extends Word {
  GermanWord({required super.word, required super.meanings});
}

class EnglishWord extends Word {
  EnglishWord({required super.word, required super.meanings});
}

class SpanishWord extends Word {
  SpanishWord({required super.word, required super.meanings});
}
