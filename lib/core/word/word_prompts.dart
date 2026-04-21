import 'dart:convert';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/core/word/ai_word_response.dart';

class WordPrompts {
  static final String _englishSchema = jsonEncode(
    AIWordResponse.getSchema(
      Schema(
        type: SchemaType.object,
        properties: {'isIrregular': Schema(type: SchemaType.boolean, nullable: true)},
        required: ['isIrregular'],
      ),
    ).toJson(),
  );

  static final String _germanSchema = jsonEncode(
    AIWordResponse.getSchema(
      Schema(
        type: SchemaType.object,
        properties: {
          'gender': Schema(type: SchemaType.string, enumValues: ['masculine', 'feminine', 'neuter'], nullable: true),
          'pluralForm': Schema(type: SchemaType.string, nullable: true),
          'isSeparable': Schema(type: SchemaType.boolean, nullable: true),
          'separablePrefix': Schema(type: SchemaType.string, nullable: true),
          'genitiveForm': Schema(type: SchemaType.string, nullable: true),
        },
        required: ['gender', 'pluralForm', 'isSeparable', 'separablePrefix', 'genitiveForm'],
      ),
    ).toJson(),
  );

  static final String _spanishSchema = jsonEncode(
    AIWordResponse.getSchema(
      Schema(
        type: SchemaType.object,
        properties: {
          'gender': Schema(type: SchemaType.string, enumValues: ['masculine', 'feminine'], nullable: true),
          'pluralForm': Schema(type: SchemaType.string, nullable: true),
          'isReflexive': Schema(type: SchemaType.boolean, nullable: true),
          'verbType': Schema(type: SchemaType.string, enumValues: ['regular', 'irregular', 'stemChanging'], nullable: true),
        },
        required: ['gender', 'pluralForm', 'isReflexive', 'verbType'],
      ),
    ).toJson(),
  );

  static (String prompt, String schema) generateWordRequest(LanguageLocale targetLocale, LanguageLocale nativeLocale, String word) {
    final prompt =
        '''
  You are an expert lexicographer and language teacher.
  Provide a comprehensive dictionary entry for the word "$word" in ${targetLocale.name}.
  The user's native language is ${nativeLocale.name}. Use it for the meanings and example translations.
  Include all common meanings, parts of speech, and provide clear example sentences for each meaning.
  Analyze all grammar details required by the schema (like gender, plural forms, irregularity, etc.).
  ''';

    final String schema = switch (targetLocale) {
      LanguageLocale.en => _englishSchema,
      LanguageLocale.de => _germanSchema,
      LanguageLocale.es => _spanishSchema,
    };

    return (prompt, schema);
  }
}
