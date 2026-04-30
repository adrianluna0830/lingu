class PronunciationAssessmentResult {
  final String recognitionStatus; 
  final String displayText;
  final List<PronunciationAssessmentNBest> nBest;

  const PronunciationAssessmentResult({
    required this.recognitionStatus,
    required this.displayText,
    required this.nBest,
  });

  bool get isSuccess => recognitionStatus == 'Success' || recognitionStatus == '0';
}

class PronunciationAssessmentNBest {
  final double confidence;
  final String lexical;
  final String itn;
  final String maskedItn;
  final String display;
  final PronunciationAssessmentScoresResult pronunciationAssessment;
  final List<PronunciationAssessmentWordResult> words;

  const PronunciationAssessmentNBest({
    required this.confidence,
    required this.lexical,
    required this.itn,
    required this.maskedItn,
    required this.display,
    required this.pronunciationAssessment,
    required this.words,
  });
}

class PronunciationAssessmentScoresResult {
  final double accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
  final double? pronScore;
  final double? prosodyScore; 

  const PronunciationAssessmentScoresResult({
    required this.accuracyScore,
    this.fluencyScore,
    this.completenessScore,
    this.pronScore,
    this.prosodyScore,
  });
}

class PronunciationAssessmentWordResult {
  final String word;
  final int offset;
  final int duration;
  final double confidence;
  final WordPronunciationAssessmentResult pronunciationAssessment;
  final List<PronunciationAssessmentSyllableResult>? syllables;
  final List<PronunciationAssessmentPhonemeResult>? phonemes; 

  const PronunciationAssessmentWordResult({
    required this.word,
    required this.offset,
    required this.duration,
    required this.confidence,
    required this.pronunciationAssessment,
    this.syllables,
    this.phonemes,
  });
}

class WordPronunciationAssessmentResult {
  final double accuracyScore;
  final String errorType; 

  const WordPronunciationAssessmentResult({
    required this.accuracyScore,
    required this.errorType,
  });
}

class PronunciationAssessmentSyllableResult {
  final String syllable;
  final double accuracyScore;
  final int offset;
  final int duration;

  const PronunciationAssessmentSyllableResult({
    required this.syllable,
    required this.accuracyScore,
    required this.offset,
    required this.duration,
  });
}

class PronunciationAssessmentPhonemeResult {
  final String phoneme;
  final double accuracyScore;
  final int offset;
  final int duration;
  final List<PronunciationAssessmentNBestPhoneme>? nBestPhonemes;

  const PronunciationAssessmentPhonemeResult({
    required this.phoneme,
    required this.accuracyScore,
    required this.offset,
    required this.duration,
    this.nBestPhonemes,
  });
}

class PronunciationAssessmentNBestPhoneme {
  final String phoneme;
  final double score;

  const PronunciationAssessmentNBestPhoneme({
    required this.phoneme,
    required this.score,
  });
}
