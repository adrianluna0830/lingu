import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/core/word/word.dart';

class AIWordResponse<T> {
  final String word;
  final List<AIMeaningResponse<T>> meanings;

  AIWordResponse({required this.word, required this.meanings});

  factory AIWordResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) detailsFromJson) {
    return AIWordResponse(word: json['word'] as String, meanings: (json['meanings'] as List).map((m) => AIMeaningResponse<T>.fromJson(m as Map<String, dynamic>, detailsFromJson)).toList());
  }

  static Schema getSchema(Schema languageSpecificDetails) {
    return Schema(
      type: SchemaType.object,
      properties: {
        'word': Schema(type: SchemaType.string, description: 'The word being defined.'),
        'meanings': Schema(
          type: SchemaType.array,
          items: Schema(
            type: SchemaType.object,
            properties: {
              'meaning': Schema(type: SchemaType.string, description: 'A clear definition of the word in the user\'s native language.'),
              'partOfSpeech': Schema(
                type: SchemaType.string,
                description: 'The grammatical category of the word.',
                enumValues: ['noun', 'verb', 'adjective', 'adverb', 'pronoun', 'preposition', 'conjunction', 'interjection'],
              ),
              'examples': Schema(
                type: SchemaType.array,
                items: Schema(
                  type: SchemaType.object,
                  properties: {
                    'translation': Schema(type: SchemaType.string, description: 'Translation of the example sentence to the user\'s native language.'),
                    'example': Schema(type: SchemaType.string, description: 'A natural example sentence using the word in its target language context.'),
                  },
                  required: ['translation', 'example'],
                ),
              ),
              'ssmlAudioPrompt': Schema(
                type: SchemaType.string,
                description: 'The SSML (Speech Synthesis Markup Language) markup for the word pronunciation. Ensure high quality and natural intonation using phoneme tags if needed.',
              ),
              'imageDescription': Schema(type: SchemaType.string, description: 'A vivid, detailed description for an image generator to create a visual representation of this specific word meaning.'),
              'imageCredits': Schema(type: SchemaType.string, description: 'The credits or author of the image.'),
              'languageSpecificDetails': languageSpecificDetails,
            },
            required: ['meaning', 'partOfSpeech', 'examples', 'ssmlAudioPrompt', 'imageDescription', 'imageCredits', 'languageSpecificDetails'],
          ),
        ),
      },
      required: ['word', 'meanings'],
    );
  }
}

class AIMeaningResponse<T> {
  final String meaning;
  final PartOfSpeech partOfSpeech;
  final List<AIExampleResponse> examples;
  final String ssmlAudioPrompt;
  final String imageDescription;
  final String imageCredits;
  final T languageSpecificDetails;

  AIMeaningResponse({
    required this.meaning,
    required this.partOfSpeech,
    required this.examples,
    required this.ssmlAudioPrompt,
    required this.imageDescription,
    required this.imageCredits,
    required this.languageSpecificDetails,
  });

  factory AIMeaningResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) detailsFromJson) {
    return AIMeaningResponse(
      meaning: json['meaning'] as String,
      partOfSpeech: PartOfSpeech.values.byName(json['partOfSpeech'] as String),
      examples: (json['examples'] as List).map((e) => AIExampleResponse.fromJson(e as Map<String, dynamic>)).toList(),
      ssmlAudioPrompt: json['ssmlAudioPrompt'] as String,
      imageDescription: json['imageDescription'] as String,
      imageCredits: json['imageCredits'] as String,
      languageSpecificDetails: detailsFromJson(json['languageSpecificDetails'] as Map<String, dynamic>),
    );
  }
}

class AIExampleResponse {
  final String translation;
  final String example;

  AIExampleResponse({required this.translation, required this.example});

  factory AIExampleResponse.fromJson(Map<String, dynamic> json) {
    return AIExampleResponse(translation: json['translation'] as String, example: json['example'] as String);
  }
}
