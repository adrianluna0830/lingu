import 'package:lingu/domain/chat/models/chat/translated_text.dart';
import 'package:lingu/domain/chat/models/feedback/sentence_feedback.dart';
import 'package:lingu/domain/chat/models/enums/error_severity_enum.dart';
import 'package:lingu/domain/chat/services/pronunciation_feedback_service.dart';
import 'package:lingu/domain/chat/services/statement_feedback_service.dart';
import 'package:lingu/domain/word/models/ai_word_response.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_schema_service.dart';

class AiSchemaService implements IAiSchemaService {
  @override
  Map<String, dynamic> getSentenceFeedbackSchema() {
    return {
      'type': 'object',
      'properties': {
        'correction': {'type': 'string'},
        'explanation': {'type': 'string'},
        'severity': {
          'type': 'string',
          'enum': ['bad', 'neutral'],
        },
      },
      'additionalProperties': false,
    };
  }

  @override
  SentenceFeedback parseSentenceFeedback(Map<String, dynamic> json) {
    return SentenceFeedback(
      correction: json['correction'] as String,
      explanation: json['explanation'] as String,
      severity: ErrorSeverityEnum.values.firstWhere((e) => e.name == json['severity']),
    );
  }

  @override
  Map<String, dynamic> getTranslatedTextSchema() {
    return {
      'type': 'object',
      'properties': {
        'targetText': {'type': 'string'},
        'translation': {'type': 'string'},
      },
      'required': ['targetText', 'translation'],
      'additionalProperties': false,
    };
  }

  @override
  TranslatedText parseTranslatedText(Map<String, dynamic> json) {
    return TranslatedText(
      targetText: json['targetText'] as String,
      translation: json['translation'] as String,
    );
  }

  @override
  Map<String, dynamic> getStatementFeedbackResponseSchema({required bool hasNativeLanguage}) {
    return {
      'type': 'object',
      'properties': {
        'fluency': getSentenceFeedbackSchema(),
        'grammar': getSentenceFeedbackSchema(),
        if (hasNativeLanguage) 'translatedText': getTranslatedTextSchema(),
      },
      'required': ['fluency', 'grammar', if (hasNativeLanguage) 'translatedText'],
      'additionalProperties': false,
    };
  }

  @override
  StatementFeedbackResponse parseStatementFeedbackResponse(Map<String, dynamic> json) {
    return StatementFeedbackResponse(
      fluency: json['fluency'] != null ? parseSentenceFeedback(json['fluency'] as Map<String, dynamic>) : null,
      grammar: json['grammar'] != null ? parseSentenceFeedback(json['grammar'] as Map<String, dynamic>) : null,
      translatedText: json['translatedText'] != null ? parseTranslatedText(json['translatedText'] as Map<String, dynamic>) : null,
    );
  }

  @override
  Map<String, dynamic> getAIPronunciationResponseSchema(String nativeLanguageName) {
    return {
      'type': 'object',
      'properties': {
        'wordSSML': {'type': 'string', 'description': 'SSML of the word for correct pronunciation.'},
        'syllableFeedback': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'syllablePlainText': {
                'type': 'string',
                'description': 'The exact syllable string from the original word spelling. Concatenating all syllablePlainText fields MUST exactly equal the original word.',
              },
              'ipa': {
                'type': 'string',
                'description': 'IPA phonetic transcription for this syllable only, without brackets or slashes.',
              },
              'feedback': {
                'type': 'object',
                'description': 'Optional feedback if the syllable was mispronounced. Null if correct.',
                'properties': {
                  'feedback': {'type': 'string', 'description': 'Feedback in $nativeLanguageName.'},
                  'severity': {
                    'type': 'string',
                    'enum': ['bad', 'neutral'],
                  },
                },
                'required': ['feedback', 'severity'],
                'additionalProperties': false,
              },
            },
            'required': ['syllablePlainText', 'ipa'],
            'additionalProperties': false,
          },
        },
      },
      'required': ['wordSSML', 'syllableFeedback'],
      'additionalProperties': false,
    };
  }

  @override
  AIPronunciationResponse parseAIPronunciationResponse(Map<String, dynamic> json) {
    return AIPronunciationResponse(
      wordSSML: json['wordSSML'] as String,
      syllableFeedback: (json['syllableFeedback'] as List).map((item) => AISyllableResponse.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  @override
  Map<String, dynamic> getAIOverallPronunciationResponseSchema(String nativeLanguageName) {
    return {
      'type': 'object',
      'properties': {
        'fluencyFeedback': {
          'type': 'string',
          'description': 'Tips on rhythm, fluency or native-like intonation in $nativeLanguageName. Empty string if no major tips are needed.',
        },
      },
      'required': ['fluencyFeedback'],
      'additionalProperties': false,
    };
  }

  @override
  AIOverallPronunciationResponse parseAIOverallPronunciationResponse(Map<String, dynamic> json) {
    final feedback = json['fluencyFeedback'] as String?;
    return AIOverallPronunciationResponse(fluencyFeedback: feedback?.isEmpty == true ? null : feedback);
  }

  @override
  Map<String, dynamic> getAIWordResponseSchema(Map<String, dynamic> languageSpecificDetails) {
    return {
      'type': 'object',
      'properties': {
        'word': {'type': 'string', 'description': 'The word being defined.'},
        'meanings': {
          'type': 'array',
          'items': {
            'type': 'object',
            'properties': {
              'meaning': {'type': 'string', 'description': "A clear definition in the user's native language."},
              'partOfSpeech': {
                'type': 'string',
                'enum': ['noun', 'verb', 'adjective', 'adverb', 'pronoun', 'preposition', 'conjunction', 'interjection'],
              },
              'examples': {
                'type': 'array',
                'items': {
                  'type': 'object',
                  'properties': {
                    'example': {'type': 'string', 'description': 'Natural example sentence in the target language.'},
                    'translation': {'type': 'string', 'description': "Translation to the user's native language."},
                  },
                  'required': ['example', 'translation'],
                  'additionalProperties': false,
                },
              },
              'ssmlAudioPrompt': {'type': 'string', 'description': 'SSML markup for natural word pronunciation.'},
              'imageDescription': {'type': 'string', 'description': 'Vivid description for an image generator to represent this meaning.'},
              'imageCredits': {'type': 'string', 'description': 'Credits or author of the image.'},
              'languageSpecificDetails': languageSpecificDetails,
            },
            'required': ['meaning', 'partOfSpeech', 'examples', 'ssmlAudioPrompt', 'imageDescription', 'imageCredits', 'languageSpecificDetails'],
            'additionalProperties': false,
          },
        },
      },
      'required': ['word', 'meanings'],
      'additionalProperties': false,
    };
  }

  AIExampleResponse _parseAIExampleResponse(Map<String, dynamic> json) {
    return AIExampleResponse(
      translation: json['translation'] as String,
      example: json['example'] as String,
    );
  }

  AIMeaningResponse<T> _parseAIMeaningResponse<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) detailsFromJson) {
    return AIMeaningResponse(
      meaning: json['meaning'] as String,
      partOfSpeech: PartOfSpeech.values.firstWhere((e) => e.name == json['partOfSpeech']),
      examples: (json['examples'] as List).map((e) => _parseAIExampleResponse(e as Map<String, dynamic>)).toList(),
      ssmlAudioPrompt: json['ssmlAudioPrompt'] as String,
      imageDescription: json['imageDescription'] as String,
      imageCredits: json['imageCredits'] as String,
      languageSpecificDetails: detailsFromJson(json['languageSpecificDetails'] as Map<String, dynamic>),
    );
  }

  @override
  AIWordResponse<T> parseAIWordResponse<T>(Map<String, dynamic> json, T Function(Map<String, dynamic>) detailsFromJson) {
    return AIWordResponse(
      word: json['word'] as String,
      meanings: (json['meanings'] as List).map((m) => _parseAIMeaningResponse<T>(m as Map<String, dynamic>, detailsFromJson)).toList(),
    );
  }

  @override
  Map<String, dynamic> getEnglishWordDetailsSchema() {
    return {
      'type': 'object',
      'properties': {
        'isIrregular': {'type': 'boolean'},
      },
      'required': ['isIrregular'],
      'additionalProperties': false,
    };
  }

  @override
  Map<String, dynamic> getGermanWordDetailsSchema() {
    return {
      'type': 'object',
      'properties': {
        'gender': {'type': 'string', 'enum': ['masculine', 'feminine', 'neuter']},
        'pluralForm': {'type': 'string'},
        'isSeparable': {'type': 'boolean'},
        'separablePrefix': {'type': 'string'},
        'genitiveForm': {'type': 'string'},
      },
      'required': ['gender', 'pluralForm', 'isSeparable', 'separablePrefix', 'genitiveForm'],
      'additionalProperties': false,
    };
  }

  @override
  Map<String, dynamic> getSpanishWordDetailsSchema() {
    return {
      'type': 'object',
      'properties': {
        'gender': {'type': 'string', 'enum': ['masculine', 'feminine']},
        'pluralForm': {'type': 'string'},
        'isReflexive': {'type': 'boolean'},
        'verbType': {'type': 'string', 'enum': ['regular', 'irregular', 'stemChanging']},
      },
      'required': ['gender', 'pluralForm', 'isReflexive', 'verbType'],
      'additionalProperties': false,
    };
  }
}