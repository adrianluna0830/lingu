@MappableLib(caseStyle: CaseStyle.pascalCase)

import 'package:dart_mappable/dart_mappable.dart';

part 'raw_pronunciation_assessment_response.mapper.dart';



@MappableClass()
class RawPronunciationAssessmentResponse with RawPronunciationAssessmentResponseMappable {
  final String id;
  final String recognitionStatus; 
  final int offset;
  final int duration;
  final String displayText;
  final int? channel;
  final double? snr;
  final List<NBest> nBest;

  const RawPronunciationAssessmentResponse({
    required this.id,
    required this.recognitionStatus,
    required this.offset,
    required this.duration,
    required this.displayText,
    this.channel,
    this.snr,
    required this.nBest,
  });

  bool get isSuccess => recognitionStatus == 'Success' || recognitionStatus == '0';


  static final fromMap = RawPronunciationAssessmentResponseMapper.fromMap;
  static final fromJson = RawPronunciationAssessmentResponseMapper.fromJson;
}

@MappableClass()
class NBest with NBestMappable {
  final double confidence;
  final String lexical;
  @MappableField(key: 'ITN')
  final String itn;
  @MappableField(key: 'MaskedITN')
  final String maskedItn;
  final String display;
  final PronunciationAssessmentScores pronunciationAssessment;
  final List<WordResult> words;

  const NBest({
    required this.confidence,
    required this.lexical,
    required this.itn,
    required this.maskedItn,
    required this.display,
    required this.pronunciationAssessment,
    required this.words,
  });
}

@MappableClass()
class PronunciationAssessmentScores with PronunciationAssessmentScoresMappable {
  final double accuracyScore;
  final double? fluencyScore;
  final double? completenessScore;
  final double? pronScore;
  final double? prosodyScore; 

  const PronunciationAssessmentScores({
    required this.accuracyScore,
    this.fluencyScore,
    this.completenessScore,
    this.pronScore,
    this.prosodyScore,
  });
}

@MappableClass()
class WordResult with WordResultMappable {
  final String word;
  final int offset;
  final int duration;
  final double confidence;
  final WordPronunciationAssessment pronunciationAssessment;
  final List<SyllableResult>? syllables;
  final List<PhonemeResult>? phonemes; 

  const WordResult({
    required this.word,
    required this.offset,
    required this.duration,
    required this.confidence,
    required this.pronunciationAssessment,
    this.syllables,
    this.phonemes,
  });
}

@MappableClass()
class WordPronunciationAssessment with WordPronunciationAssessmentMappable {
  final double accuracyScore;
  final String errorType; 

  const WordPronunciationAssessment({
    required this.accuracyScore,
    required this.errorType,
  });
}

@MappableClass()
class SyllableResult with SyllableResultMappable {
  @MappableField(key: 'Syllable')
  final String syllable;
  final SyllableAssessment pronunciationAssessment;
  final int offset;
  final int duration;


  const SyllableResult({
    required this.syllable,
    required this.pronunciationAssessment,
    required this.offset,
    required this.duration,
  });
}

@MappableClass()
class SyllableAssessment with SyllableAssessmentMappable {
  final double accuracyScore;

  const SyllableAssessment({required this.accuracyScore});
}


@MappableClass()
class PhonemeResult with PhonemeResultMappable {
  @MappableField(key: 'Phoneme')
  final String phoneme;
  final PhonemeAssessment pronunciationAssessment;
  final int offset;
  final int duration;

  const PhonemeResult({
    required this.phoneme,
    required this.pronunciationAssessment,
    required this.offset,
    required this.duration,
  });
}

@MappableClass()
class PhonemeAssessment with PhonemeAssessmentMappable {
  final double accuracyScore;
  final List<NBestPhoneme>? nBestPhonemes;

  const PhonemeAssessment({
    required this.accuracyScore,
    this.nBestPhonemes,
  });
}

@MappableClass()
class NBestPhoneme with NBestPhonemeMappable {
  @MappableField(key: 'Phoneme')
  final String phoneme;
  final double score;

  const NBestPhoneme({
    required this.phoneme,
    required this.score,
  });
}