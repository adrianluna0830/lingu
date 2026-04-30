import 'package:lingu/domain/word/models/grammatical_gender.dart';

class SpanishWordDetails {
  final GrammaticalGender? gender;
  final String? pluralForm;
  final bool? isReflexive;
  final VerbConjugationType? verbType;

  SpanishWordDetails({
    required this.gender,
    required this.pluralForm,
    required this.isReflexive,
    required this.verbType,
  });

  factory SpanishWordDetails.fromJson(Map<String, dynamic> json) {
    return SpanishWordDetails(
      gender: json['gender'] == null ? null : GrammaticalGender.values.byName(json['gender'] as String),
      pluralForm: json['pluralForm'] as String?,
      isReflexive: json['isReflexive'] as bool?,
      verbType: json['verbType'] == null ? null : VerbConjugationType.values.byName(json['verbType'] as String),
    );
  }
}

enum VerbConjugationType { regular, irregular, stemChanging }
