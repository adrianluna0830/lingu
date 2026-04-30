class EnglishWordDetails {
  final bool? isIrregular;

  EnglishWordDetails({
    required this.isIrregular,
  });

  factory EnglishWordDetails.fromJson(Map<String, dynamic> json) {
    return EnglishWordDetails(
      isIrregular: json['isIrregular'] as bool?,
    );
  }
}
