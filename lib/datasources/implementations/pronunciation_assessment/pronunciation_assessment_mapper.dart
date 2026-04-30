import 'package:lingu/datasources/implementations/pronunciation_assessment/pronunciation_assessment_dto.dart';
import 'package:lingu/domain/pronunciation/models/pronunciation_assessment_result.dart';

class PronunciationAssessmentMapper {
  static PronunciationAssessmentResult toEntity(PronunciationAssessmentDto dto) {
    return PronunciationAssessmentResult(
      recognitionStatus: dto.recognitionStatus,
      displayText: dto.displayText,
      nBest: dto.nBest.map(_mapNBest).toList(),
    );
  }

  static PronunciationAssessmentNBest _mapNBest(NBest dto) {
    return PronunciationAssessmentNBest(
      confidence: dto.confidence,
      lexical: dto.lexical,
      itn: dto.itn,
      maskedItn: dto.maskedItn,
      display: dto.display,
      pronunciationAssessment: _mapScores(dto.pronunciationAssessment),
      words: dto.words.map(_mapWord).toList(),
    );
  }

  static PronunciationAssessmentScoresResult _mapScores(PronunciationAssessmentScores dto) {
    return PronunciationAssessmentScoresResult(
      accuracyScore: dto.accuracyScore,
      fluencyScore: dto.fluencyScore,
      completenessScore: dto.completenessScore,
      pronScore: dto.pronScore,
      prosodyScore: dto.prosodyScore,
    );
  }

  static PronunciationAssessmentWordResult _mapWord(WordResult dto) {
    return PronunciationAssessmentWordResult(
      word: dto.word,
      offset: dto.offset,
      duration: dto.duration,
      confidence: dto.confidence,
      pronunciationAssessment: _mapWordAssessment(dto.pronunciationAssessment),
      syllables: dto.syllables?.map(_mapSyllable).toList(),
      phonemes: dto.phonemes?.map(_mapPhoneme).toList(),
    );
  }

  static WordPronunciationAssessmentResult _mapWordAssessment(WordPronunciationAssessment dto) {
    return WordPronunciationAssessmentResult(
      accuracyScore: dto.accuracyScore,
      errorType: dto.errorType,
    );
  }

  static PronunciationAssessmentSyllableResult _mapSyllable(SyllableResult dto) {
    return PronunciationAssessmentSyllableResult(
      syllable: dto.syllable,
      accuracyScore: dto.pronunciationAssessment.accuracyScore,
      offset: dto.offset,
      duration: dto.duration,
    );
  }

  static PronunciationAssessmentPhonemeResult _mapPhoneme(PhonemeResult dto) {
    return PronunciationAssessmentPhonemeResult(
      phoneme: dto.phoneme,
      accuracyScore: dto.pronunciationAssessment.accuracyScore,
      offset: dto.offset,
      duration: dto.duration,
      nBestPhonemes: dto.pronunciationAssessment.nBestPhonemes?.map(_mapNBestPhoneme).toList(),
    );
  }

  static PronunciationAssessmentNBestPhoneme _mapNBestPhoneme(NBestPhoneme dto) {
    return PronunciationAssessmentNBestPhoneme(
      phoneme: dto.phoneme,
      score: dto.score,
    );
  }
}
