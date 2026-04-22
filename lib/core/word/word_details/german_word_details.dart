import 'package:lingu/core/models/grammatical_gender.dart';

class GermanWordDetails {
  final GrammaticalGender? gender;
  final String? pluralForm;
  final bool? isSeparable;
  final String? separablePrefix;
  final String? genitiveForm;

  GermanWordDetails({required this.gender, required this.pluralForm, required this.isSeparable, required this.separablePrefix, required this.genitiveForm});

  factory GermanWordDetails.fromJson(Map<String, dynamic> json) {
    return GermanWordDetails(
      gender: json['gender'] == null ? null : GrammaticalGender.values.byName(json['gender'] as String),
      pluralForm: json['pluralForm'] as String?,
      isSeparable: json['isSeparable'] as bool?,
      separablePrefix: json['separablePrefix'] as String?,
      genitiveForm: json['genitiveForm'] as String?,
    );
  }
}
