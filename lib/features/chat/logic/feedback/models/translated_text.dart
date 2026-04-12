import 'package:googleai_dart/googleai_dart.dart';

class TranslatedText {
  final String targetText;
  final String translation;

  TranslatedText({
    required this.targetText,
    required this.translation,
  });

  static Schema get schema => Schema(
        type: SchemaType.object,
        properties: {
          'targetText': Schema(type: SchemaType.string),
          'translation': Schema(type: SchemaType.string),
        },
        nullable: true,
      );

  factory TranslatedText.fromJson(Map<String, dynamic> json) {
    return TranslatedText(
      targetText: json['targetText'] as String,
      translation: json['translation'] as String,
    );
  }
}
