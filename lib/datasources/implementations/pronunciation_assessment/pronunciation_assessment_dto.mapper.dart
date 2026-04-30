// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'pronunciation_assessment_dto.dart';

class PronunciationAssessmentDtoMapper
    extends ClassMapperBase<PronunciationAssessmentDto> {
  PronunciationAssessmentDtoMapper._();

  static PronunciationAssessmentDtoMapper? _instance;
  static PronunciationAssessmentDtoMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PronunciationAssessmentDtoMapper._(),
      );
      NBestMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PronunciationAssessmentDto';

  static String _$id(PronunciationAssessmentDto v) => v.id;
  static const Field<PronunciationAssessmentDto, String> _f$id = Field(
    'id',
    _$id,
    key: r'Id',
  );
  static String _$recognitionStatus(PronunciationAssessmentDto v) =>
      v.recognitionStatus;
  static const Field<PronunciationAssessmentDto, String> _f$recognitionStatus =
      Field(
        'recognitionStatus',
        _$recognitionStatus,
        key: r'RecognitionStatus',
      );
  static int _$offset(PronunciationAssessmentDto v) => v.offset;
  static const Field<PronunciationAssessmentDto, int> _f$offset = Field(
    'offset',
    _$offset,
    key: r'Offset',
  );
  static int _$duration(PronunciationAssessmentDto v) => v.duration;
  static const Field<PronunciationAssessmentDto, int> _f$duration = Field(
    'duration',
    _$duration,
    key: r'Duration',
  );
  static String _$displayText(PronunciationAssessmentDto v) => v.displayText;
  static const Field<PronunciationAssessmentDto, String> _f$displayText = Field(
    'displayText',
    _$displayText,
    key: r'DisplayText',
  );
  static int? _$channel(PronunciationAssessmentDto v) => v.channel;
  static const Field<PronunciationAssessmentDto, int> _f$channel = Field(
    'channel',
    _$channel,
    key: r'Channel',
    opt: true,
  );
  static double? _$snr(PronunciationAssessmentDto v) => v.snr;
  static const Field<PronunciationAssessmentDto, double> _f$snr = Field(
    'snr',
    _$snr,
    key: r'Snr',
    opt: true,
  );
  static List<NBest> _$nBest(PronunciationAssessmentDto v) => v.nBest;
  static const Field<PronunciationAssessmentDto, List<NBest>> _f$nBest = Field(
    'nBest',
    _$nBest,
    key: r'NBest',
  );

  @override
  final MappableFields<PronunciationAssessmentDto> fields = const {
    #id: _f$id,
    #recognitionStatus: _f$recognitionStatus,
    #offset: _f$offset,
    #duration: _f$duration,
    #displayText: _f$displayText,
    #channel: _f$channel,
    #snr: _f$snr,
    #nBest: _f$nBest,
  };

  static PronunciationAssessmentDto _instantiate(DecodingData data) {
    return PronunciationAssessmentDto(
      id: data.dec(_f$id),
      recognitionStatus: data.dec(_f$recognitionStatus),
      offset: data.dec(_f$offset),
      duration: data.dec(_f$duration),
      displayText: data.dec(_f$displayText),
      channel: data.dec(_f$channel),
      snr: data.dec(_f$snr),
      nBest: data.dec(_f$nBest),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PronunciationAssessmentDto fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PronunciationAssessmentDto>(map);
  }

  static PronunciationAssessmentDto fromJson(String json) {
    return ensureInitialized().decodeJson<PronunciationAssessmentDto>(json);
  }
}

mixin PronunciationAssessmentDtoMappable {
  String toJson() {
    return PronunciationAssessmentDtoMapper.ensureInitialized()
        .encodeJson<PronunciationAssessmentDto>(
          this as PronunciationAssessmentDto,
        );
  }

  Map<String, dynamic> toMap() {
    return PronunciationAssessmentDtoMapper.ensureInitialized()
        .encodeMap<PronunciationAssessmentDto>(
          this as PronunciationAssessmentDto,
        );
  }

  PronunciationAssessmentDtoCopyWith<
    PronunciationAssessmentDto,
    PronunciationAssessmentDto,
    PronunciationAssessmentDto
  >
  get copyWith =>
      _PronunciationAssessmentDtoCopyWithImpl<
        PronunciationAssessmentDto,
        PronunciationAssessmentDto
      >(this as PronunciationAssessmentDto, $identity, $identity);
  @override
  String toString() {
    return PronunciationAssessmentDtoMapper.ensureInitialized().stringifyValue(
      this as PronunciationAssessmentDto,
    );
  }

  @override
  bool operator ==(Object other) {
    return PronunciationAssessmentDtoMapper.ensureInitialized().equalsValue(
      this as PronunciationAssessmentDto,
      other,
    );
  }

  @override
  int get hashCode {
    return PronunciationAssessmentDtoMapper.ensureInitialized().hashValue(
      this as PronunciationAssessmentDto,
    );
  }
}

extension PronunciationAssessmentDtoValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PronunciationAssessmentDto, $Out> {
  PronunciationAssessmentDtoCopyWith<$R, PronunciationAssessmentDto, $Out>
  get $asPronunciationAssessmentDto => $base.as(
    (v, t, t2) => _PronunciationAssessmentDtoCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PronunciationAssessmentDtoCopyWith<
  $R,
  $In extends PronunciationAssessmentDto,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, NBest, NBestCopyWith<$R, NBest, NBest>> get nBest;
  $R call({
    String? id,
    String? recognitionStatus,
    int? offset,
    int? duration,
    String? displayText,
    int? channel,
    double? snr,
    List<NBest>? nBest,
  });
  PronunciationAssessmentDtoCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PronunciationAssessmentDtoCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PronunciationAssessmentDto, $Out>
    implements
        PronunciationAssessmentDtoCopyWith<
          $R,
          PronunciationAssessmentDto,
          $Out
        > {
  _PronunciationAssessmentDtoCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PronunciationAssessmentDto> $mapper =
      PronunciationAssessmentDtoMapper.ensureInitialized();
  @override
  ListCopyWith<$R, NBest, NBestCopyWith<$R, NBest, NBest>> get nBest =>
      ListCopyWith(
        $value.nBest,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(nBest: v),
      );
  @override
  $R call({
    String? id,
    String? recognitionStatus,
    int? offset,
    int? duration,
    String? displayText,
    Object? channel = $none,
    Object? snr = $none,
    List<NBest>? nBest,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (recognitionStatus != null) #recognitionStatus: recognitionStatus,
      if (offset != null) #offset: offset,
      if (duration != null) #duration: duration,
      if (displayText != null) #displayText: displayText,
      if (channel != $none) #channel: channel,
      if (snr != $none) #snr: snr,
      if (nBest != null) #nBest: nBest,
    }),
  );
  @override
  PronunciationAssessmentDto $make(CopyWithData data) =>
      PronunciationAssessmentDto(
        id: data.get(#id, or: $value.id),
        recognitionStatus: data.get(
          #recognitionStatus,
          or: $value.recognitionStatus,
        ),
        offset: data.get(#offset, or: $value.offset),
        duration: data.get(#duration, or: $value.duration),
        displayText: data.get(#displayText, or: $value.displayText),
        channel: data.get(#channel, or: $value.channel),
        snr: data.get(#snr, or: $value.snr),
        nBest: data.get(#nBest, or: $value.nBest),
      );

  @override
  PronunciationAssessmentDtoCopyWith<$R2, PronunciationAssessmentDto, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PronunciationAssessmentDtoCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NBestMapper extends ClassMapperBase<NBest> {
  NBestMapper._();

  static NBestMapper? _instance;
  static NBestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NBestMapper._());
      PronunciationAssessmentScoresMapper.ensureInitialized();
      WordResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'NBest';

  static double _$confidence(NBest v) => v.confidence;
  static const Field<NBest, double> _f$confidence = Field(
    'confidence',
    _$confidence,
    key: r'Confidence',
  );
  static String _$lexical(NBest v) => v.lexical;
  static const Field<NBest, String> _f$lexical = Field(
    'lexical',
    _$lexical,
    key: r'Lexical',
  );
  static String _$itn(NBest v) => v.itn;
  static const Field<NBest, String> _f$itn = Field('itn', _$itn, key: r'ITN');
  static String _$maskedItn(NBest v) => v.maskedItn;
  static const Field<NBest, String> _f$maskedItn = Field(
    'maskedItn',
    _$maskedItn,
    key: r'MaskedITN',
  );
  static String _$display(NBest v) => v.display;
  static const Field<NBest, String> _f$display = Field(
    'display',
    _$display,
    key: r'Display',
  );
  static PronunciationAssessmentScores _$pronunciationAssessment(NBest v) =>
      v.pronunciationAssessment;
  static const Field<NBest, PronunciationAssessmentScores>
  _f$pronunciationAssessment = Field(
    'pronunciationAssessment',
    _$pronunciationAssessment,
    key: r'PronunciationAssessment',
  );
  static List<WordResult> _$words(NBest v) => v.words;
  static const Field<NBest, List<WordResult>> _f$words = Field(
    'words',
    _$words,
    key: r'Words',
  );

  @override
  final MappableFields<NBest> fields = const {
    #confidence: _f$confidence,
    #lexical: _f$lexical,
    #itn: _f$itn,
    #maskedItn: _f$maskedItn,
    #display: _f$display,
    #pronunciationAssessment: _f$pronunciationAssessment,
    #words: _f$words,
  };

  static NBest _instantiate(DecodingData data) {
    return NBest(
      confidence: data.dec(_f$confidence),
      lexical: data.dec(_f$lexical),
      itn: data.dec(_f$itn),
      maskedItn: data.dec(_f$maskedItn),
      display: data.dec(_f$display),
      pronunciationAssessment: data.dec(_f$pronunciationAssessment),
      words: data.dec(_f$words),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NBest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NBest>(map);
  }

  static NBest fromJson(String json) {
    return ensureInitialized().decodeJson<NBest>(json);
  }
}

mixin NBestMappable {
  String toJson() {
    return NBestMapper.ensureInitialized().encodeJson<NBest>(this as NBest);
  }

  Map<String, dynamic> toMap() {
    return NBestMapper.ensureInitialized().encodeMap<NBest>(this as NBest);
  }

  NBestCopyWith<NBest, NBest, NBest> get copyWith =>
      _NBestCopyWithImpl<NBest, NBest>(this as NBest, $identity, $identity);
  @override
  String toString() {
    return NBestMapper.ensureInitialized().stringifyValue(this as NBest);
  }

  @override
  bool operator ==(Object other) {
    return NBestMapper.ensureInitialized().equalsValue(this as NBest, other);
  }

  @override
  int get hashCode {
    return NBestMapper.ensureInitialized().hashValue(this as NBest);
  }
}

extension NBestValueCopy<$R, $Out> on ObjectCopyWith<$R, NBest, $Out> {
  NBestCopyWith<$R, NBest, $Out> get $asNBest =>
      $base.as((v, t, t2) => _NBestCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NBestCopyWith<$R, $In extends NBest, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PronunciationAssessmentScoresCopyWith<
    $R,
    PronunciationAssessmentScores,
    PronunciationAssessmentScores
  >
  get pronunciationAssessment;
  ListCopyWith<$R, WordResult, WordResultCopyWith<$R, WordResult, WordResult>>
  get words;
  $R call({
    double? confidence,
    String? lexical,
    String? itn,
    String? maskedItn,
    String? display,
    PronunciationAssessmentScores? pronunciationAssessment,
    List<WordResult>? words,
  });
  NBestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NBestCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, NBest, $Out>
    implements NBestCopyWith<$R, NBest, $Out> {
  _NBestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NBest> $mapper = NBestMapper.ensureInitialized();
  @override
  PronunciationAssessmentScoresCopyWith<
    $R,
    PronunciationAssessmentScores,
    PronunciationAssessmentScores
  >
  get pronunciationAssessment => $value.pronunciationAssessment.copyWith.$chain(
    (v) => call(pronunciationAssessment: v),
  );
  @override
  ListCopyWith<$R, WordResult, WordResultCopyWith<$R, WordResult, WordResult>>
  get words => ListCopyWith(
    $value.words,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(words: v),
  );
  @override
  $R call({
    double? confidence,
    String? lexical,
    String? itn,
    String? maskedItn,
    String? display,
    PronunciationAssessmentScores? pronunciationAssessment,
    List<WordResult>? words,
  }) => $apply(
    FieldCopyWithData({
      if (confidence != null) #confidence: confidence,
      if (lexical != null) #lexical: lexical,
      if (itn != null) #itn: itn,
      if (maskedItn != null) #maskedItn: maskedItn,
      if (display != null) #display: display,
      if (pronunciationAssessment != null)
        #pronunciationAssessment: pronunciationAssessment,
      if (words != null) #words: words,
    }),
  );
  @override
  NBest $make(CopyWithData data) => NBest(
    confidence: data.get(#confidence, or: $value.confidence),
    lexical: data.get(#lexical, or: $value.lexical),
    itn: data.get(#itn, or: $value.itn),
    maskedItn: data.get(#maskedItn, or: $value.maskedItn),
    display: data.get(#display, or: $value.display),
    pronunciationAssessment: data.get(
      #pronunciationAssessment,
      or: $value.pronunciationAssessment,
    ),
    words: data.get(#words, or: $value.words),
  );

  @override
  NBestCopyWith<$R2, NBest, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _NBestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PronunciationAssessmentScoresMapper
    extends ClassMapperBase<PronunciationAssessmentScores> {
  PronunciationAssessmentScoresMapper._();

  static PronunciationAssessmentScoresMapper? _instance;
  static PronunciationAssessmentScoresMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PronunciationAssessmentScoresMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PronunciationAssessmentScores';

  static double _$accuracyScore(PronunciationAssessmentScores v) =>
      v.accuracyScore;
  static const Field<PronunciationAssessmentScores, double> _f$accuracyScore =
      Field('accuracyScore', _$accuracyScore, key: r'AccuracyScore');
  static double? _$fluencyScore(PronunciationAssessmentScores v) =>
      v.fluencyScore;
  static const Field<PronunciationAssessmentScores, double> _f$fluencyScore =
      Field('fluencyScore', _$fluencyScore, key: r'FluencyScore', opt: true);
  static double? _$completenessScore(PronunciationAssessmentScores v) =>
      v.completenessScore;
  static const Field<PronunciationAssessmentScores, double>
  _f$completenessScore = Field(
    'completenessScore',
    _$completenessScore,
    key: r'CompletenessScore',
    opt: true,
  );
  static double? _$pronScore(PronunciationAssessmentScores v) => v.pronScore;
  static const Field<PronunciationAssessmentScores, double> _f$pronScore =
      Field('pronScore', _$pronScore, key: r'PronScore', opt: true);
  static double? _$prosodyScore(PronunciationAssessmentScores v) =>
      v.prosodyScore;
  static const Field<PronunciationAssessmentScores, double> _f$prosodyScore =
      Field('prosodyScore', _$prosodyScore, key: r'ProsodyScore', opt: true);

  @override
  final MappableFields<PronunciationAssessmentScores> fields = const {
    #accuracyScore: _f$accuracyScore,
    #fluencyScore: _f$fluencyScore,
    #completenessScore: _f$completenessScore,
    #pronScore: _f$pronScore,
    #prosodyScore: _f$prosodyScore,
  };

  static PronunciationAssessmentScores _instantiate(DecodingData data) {
    return PronunciationAssessmentScores(
      accuracyScore: data.dec(_f$accuracyScore),
      fluencyScore: data.dec(_f$fluencyScore),
      completenessScore: data.dec(_f$completenessScore),
      pronScore: data.dec(_f$pronScore),
      prosodyScore: data.dec(_f$prosodyScore),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PronunciationAssessmentScores fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PronunciationAssessmentScores>(map);
  }

  static PronunciationAssessmentScores fromJson(String json) {
    return ensureInitialized().decodeJson<PronunciationAssessmentScores>(json);
  }
}

mixin PronunciationAssessmentScoresMappable {
  String toJson() {
    return PronunciationAssessmentScoresMapper.ensureInitialized()
        .encodeJson<PronunciationAssessmentScores>(
          this as PronunciationAssessmentScores,
        );
  }

  Map<String, dynamic> toMap() {
    return PronunciationAssessmentScoresMapper.ensureInitialized()
        .encodeMap<PronunciationAssessmentScores>(
          this as PronunciationAssessmentScores,
        );
  }

  PronunciationAssessmentScoresCopyWith<
    PronunciationAssessmentScores,
    PronunciationAssessmentScores,
    PronunciationAssessmentScores
  >
  get copyWith =>
      _PronunciationAssessmentScoresCopyWithImpl<
        PronunciationAssessmentScores,
        PronunciationAssessmentScores
      >(this as PronunciationAssessmentScores, $identity, $identity);
  @override
  String toString() {
    return PronunciationAssessmentScoresMapper.ensureInitialized()
        .stringifyValue(this as PronunciationAssessmentScores);
  }

  @override
  bool operator ==(Object other) {
    return PronunciationAssessmentScoresMapper.ensureInitialized().equalsValue(
      this as PronunciationAssessmentScores,
      other,
    );
  }

  @override
  int get hashCode {
    return PronunciationAssessmentScoresMapper.ensureInitialized().hashValue(
      this as PronunciationAssessmentScores,
    );
  }
}

extension PronunciationAssessmentScoresValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PronunciationAssessmentScores, $Out> {
  PronunciationAssessmentScoresCopyWith<$R, PronunciationAssessmentScores, $Out>
  get $asPronunciationAssessmentScores => $base.as(
    (v, t, t2) =>
        _PronunciationAssessmentScoresCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PronunciationAssessmentScoresCopyWith<
  $R,
  $In extends PronunciationAssessmentScores,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    double? accuracyScore,
    double? fluencyScore,
    double? completenessScore,
    double? pronScore,
    double? prosodyScore,
  });
  PronunciationAssessmentScoresCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PronunciationAssessmentScoresCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PronunciationAssessmentScores, $Out>
    implements
        PronunciationAssessmentScoresCopyWith<
          $R,
          PronunciationAssessmentScores,
          $Out
        > {
  _PronunciationAssessmentScoresCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PronunciationAssessmentScores> $mapper =
      PronunciationAssessmentScoresMapper.ensureInitialized();
  @override
  $R call({
    double? accuracyScore,
    Object? fluencyScore = $none,
    Object? completenessScore = $none,
    Object? pronScore = $none,
    Object? prosodyScore = $none,
  }) => $apply(
    FieldCopyWithData({
      if (accuracyScore != null) #accuracyScore: accuracyScore,
      if (fluencyScore != $none) #fluencyScore: fluencyScore,
      if (completenessScore != $none) #completenessScore: completenessScore,
      if (pronScore != $none) #pronScore: pronScore,
      if (prosodyScore != $none) #prosodyScore: prosodyScore,
    }),
  );
  @override
  PronunciationAssessmentScores $make(CopyWithData data) =>
      PronunciationAssessmentScores(
        accuracyScore: data.get(#accuracyScore, or: $value.accuracyScore),
        fluencyScore: data.get(#fluencyScore, or: $value.fluencyScore),
        completenessScore: data.get(
          #completenessScore,
          or: $value.completenessScore,
        ),
        pronScore: data.get(#pronScore, or: $value.pronScore),
        prosodyScore: data.get(#prosodyScore, or: $value.prosodyScore),
      );

  @override
  PronunciationAssessmentScoresCopyWith<
    $R2,
    PronunciationAssessmentScores,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PronunciationAssessmentScoresCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class WordResultMapper extends ClassMapperBase<WordResult> {
  WordResultMapper._();

  static WordResultMapper? _instance;
  static WordResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = WordResultMapper._());
      WordPronunciationAssessmentMapper.ensureInitialized();
      SyllableResultMapper.ensureInitialized();
      PhonemeResultMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'WordResult';

  static String _$word(WordResult v) => v.word;
  static const Field<WordResult, String> _f$word = Field(
    'word',
    _$word,
    key: r'Word',
  );
  static int _$offset(WordResult v) => v.offset;
  static const Field<WordResult, int> _f$offset = Field(
    'offset',
    _$offset,
    key: r'Offset',
  );
  static int _$duration(WordResult v) => v.duration;
  static const Field<WordResult, int> _f$duration = Field(
    'duration',
    _$duration,
    key: r'Duration',
  );
  static double _$confidence(WordResult v) => v.confidence;
  static const Field<WordResult, double> _f$confidence = Field(
    'confidence',
    _$confidence,
    key: r'Confidence',
  );
  static WordPronunciationAssessment _$pronunciationAssessment(WordResult v) =>
      v.pronunciationAssessment;
  static const Field<WordResult, WordPronunciationAssessment>
  _f$pronunciationAssessment = Field(
    'pronunciationAssessment',
    _$pronunciationAssessment,
    key: r'PronunciationAssessment',
  );
  static List<SyllableResult>? _$syllables(WordResult v) => v.syllables;
  static const Field<WordResult, List<SyllableResult>> _f$syllables = Field(
    'syllables',
    _$syllables,
    key: r'Syllables',
    opt: true,
  );
  static List<PhonemeResult>? _$phonemes(WordResult v) => v.phonemes;
  static const Field<WordResult, List<PhonemeResult>> _f$phonemes = Field(
    'phonemes',
    _$phonemes,
    key: r'Phonemes',
    opt: true,
  );

  @override
  final MappableFields<WordResult> fields = const {
    #word: _f$word,
    #offset: _f$offset,
    #duration: _f$duration,
    #confidence: _f$confidence,
    #pronunciationAssessment: _f$pronunciationAssessment,
    #syllables: _f$syllables,
    #phonemes: _f$phonemes,
  };

  static WordResult _instantiate(DecodingData data) {
    return WordResult(
      word: data.dec(_f$word),
      offset: data.dec(_f$offset),
      duration: data.dec(_f$duration),
      confidence: data.dec(_f$confidence),
      pronunciationAssessment: data.dec(_f$pronunciationAssessment),
      syllables: data.dec(_f$syllables),
      phonemes: data.dec(_f$phonemes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WordResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WordResult>(map);
  }

  static WordResult fromJson(String json) {
    return ensureInitialized().decodeJson<WordResult>(json);
  }
}

mixin WordResultMappable {
  String toJson() {
    return WordResultMapper.ensureInitialized().encodeJson<WordResult>(
      this as WordResult,
    );
  }

  Map<String, dynamic> toMap() {
    return WordResultMapper.ensureInitialized().encodeMap<WordResult>(
      this as WordResult,
    );
  }

  WordResultCopyWith<WordResult, WordResult, WordResult> get copyWith =>
      _WordResultCopyWithImpl<WordResult, WordResult>(
        this as WordResult,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return WordResultMapper.ensureInitialized().stringifyValue(
      this as WordResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return WordResultMapper.ensureInitialized().equalsValue(
      this as WordResult,
      other,
    );
  }

  @override
  int get hashCode {
    return WordResultMapper.ensureInitialized().hashValue(this as WordResult);
  }
}

extension WordResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WordResult, $Out> {
  WordResultCopyWith<$R, WordResult, $Out> get $asWordResult =>
      $base.as((v, t, t2) => _WordResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class WordResultCopyWith<$R, $In extends WordResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  WordPronunciationAssessmentCopyWith<
    $R,
    WordPronunciationAssessment,
    WordPronunciationAssessment
  >
  get pronunciationAssessment;
  ListCopyWith<
    $R,
    SyllableResult,
    SyllableResultCopyWith<$R, SyllableResult, SyllableResult>
  >?
  get syllables;
  ListCopyWith<
    $R,
    PhonemeResult,
    PhonemeResultCopyWith<$R, PhonemeResult, PhonemeResult>
  >?
  get phonemes;
  $R call({
    String? word,
    int? offset,
    int? duration,
    double? confidence,
    WordPronunciationAssessment? pronunciationAssessment,
    List<SyllableResult>? syllables,
    List<PhonemeResult>? phonemes,
  });
  WordResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _WordResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WordResult, $Out>
    implements WordResultCopyWith<$R, WordResult, $Out> {
  _WordResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<WordResult> $mapper =
      WordResultMapper.ensureInitialized();
  @override
  WordPronunciationAssessmentCopyWith<
    $R,
    WordPronunciationAssessment,
    WordPronunciationAssessment
  >
  get pronunciationAssessment => $value.pronunciationAssessment.copyWith.$chain(
    (v) => call(pronunciationAssessment: v),
  );
  @override
  ListCopyWith<
    $R,
    SyllableResult,
    SyllableResultCopyWith<$R, SyllableResult, SyllableResult>
  >?
  get syllables => $value.syllables != null
      ? ListCopyWith(
          $value.syllables!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(syllables: v),
        )
      : null;
  @override
  ListCopyWith<
    $R,
    PhonemeResult,
    PhonemeResultCopyWith<$R, PhonemeResult, PhonemeResult>
  >?
  get phonemes => $value.phonemes != null
      ? ListCopyWith(
          $value.phonemes!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(phonemes: v),
        )
      : null;
  @override
  $R call({
    String? word,
    int? offset,
    int? duration,
    double? confidence,
    WordPronunciationAssessment? pronunciationAssessment,
    Object? syllables = $none,
    Object? phonemes = $none,
  }) => $apply(
    FieldCopyWithData({
      if (word != null) #word: word,
      if (offset != null) #offset: offset,
      if (duration != null) #duration: duration,
      if (confidence != null) #confidence: confidence,
      if (pronunciationAssessment != null)
        #pronunciationAssessment: pronunciationAssessment,
      if (syllables != $none) #syllables: syllables,
      if (phonemes != $none) #phonemes: phonemes,
    }),
  );
  @override
  WordResult $make(CopyWithData data) => WordResult(
    word: data.get(#word, or: $value.word),
    offset: data.get(#offset, or: $value.offset),
    duration: data.get(#duration, or: $value.duration),
    confidence: data.get(#confidence, or: $value.confidence),
    pronunciationAssessment: data.get(
      #pronunciationAssessment,
      or: $value.pronunciationAssessment,
    ),
    syllables: data.get(#syllables, or: $value.syllables),
    phonemes: data.get(#phonemes, or: $value.phonemes),
  );

  @override
  WordResultCopyWith<$R2, WordResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _WordResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class WordPronunciationAssessmentMapper
    extends ClassMapperBase<WordPronunciationAssessment> {
  WordPronunciationAssessmentMapper._();

  static WordPronunciationAssessmentMapper? _instance;
  static WordPronunciationAssessmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = WordPronunciationAssessmentMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'WordPronunciationAssessment';

  static double _$accuracyScore(WordPronunciationAssessment v) =>
      v.accuracyScore;
  static const Field<WordPronunciationAssessment, double> _f$accuracyScore =
      Field('accuracyScore', _$accuracyScore, key: r'AccuracyScore');
  static String _$errorType(WordPronunciationAssessment v) => v.errorType;
  static const Field<WordPronunciationAssessment, String> _f$errorType = Field(
    'errorType',
    _$errorType,
    key: r'ErrorType',
  );

  @override
  final MappableFields<WordPronunciationAssessment> fields = const {
    #accuracyScore: _f$accuracyScore,
    #errorType: _f$errorType,
  };

  static WordPronunciationAssessment _instantiate(DecodingData data) {
    return WordPronunciationAssessment(
      accuracyScore: data.dec(_f$accuracyScore),
      errorType: data.dec(_f$errorType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static WordPronunciationAssessment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<WordPronunciationAssessment>(map);
  }

  static WordPronunciationAssessment fromJson(String json) {
    return ensureInitialized().decodeJson<WordPronunciationAssessment>(json);
  }
}

mixin WordPronunciationAssessmentMappable {
  String toJson() {
    return WordPronunciationAssessmentMapper.ensureInitialized()
        .encodeJson<WordPronunciationAssessment>(
          this as WordPronunciationAssessment,
        );
  }

  Map<String, dynamic> toMap() {
    return WordPronunciationAssessmentMapper.ensureInitialized()
        .encodeMap<WordPronunciationAssessment>(
          this as WordPronunciationAssessment,
        );
  }

  WordPronunciationAssessmentCopyWith<
    WordPronunciationAssessment,
    WordPronunciationAssessment,
    WordPronunciationAssessment
  >
  get copyWith =>
      _WordPronunciationAssessmentCopyWithImpl<
        WordPronunciationAssessment,
        WordPronunciationAssessment
      >(this as WordPronunciationAssessment, $identity, $identity);
  @override
  String toString() {
    return WordPronunciationAssessmentMapper.ensureInitialized().stringifyValue(
      this as WordPronunciationAssessment,
    );
  }

  @override
  bool operator ==(Object other) {
    return WordPronunciationAssessmentMapper.ensureInitialized().equalsValue(
      this as WordPronunciationAssessment,
      other,
    );
  }

  @override
  int get hashCode {
    return WordPronunciationAssessmentMapper.ensureInitialized().hashValue(
      this as WordPronunciationAssessment,
    );
  }
}

extension WordPronunciationAssessmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, WordPronunciationAssessment, $Out> {
  WordPronunciationAssessmentCopyWith<$R, WordPronunciationAssessment, $Out>
  get $asWordPronunciationAssessment => $base.as(
    (v, t, t2) => _WordPronunciationAssessmentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class WordPronunciationAssessmentCopyWith<
  $R,
  $In extends WordPronunciationAssessment,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? accuracyScore, String? errorType});
  WordPronunciationAssessmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _WordPronunciationAssessmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, WordPronunciationAssessment, $Out>
    implements
        WordPronunciationAssessmentCopyWith<
          $R,
          WordPronunciationAssessment,
          $Out
        > {
  _WordPronunciationAssessmentCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<WordPronunciationAssessment> $mapper =
      WordPronunciationAssessmentMapper.ensureInitialized();
  @override
  $R call({double? accuracyScore, String? errorType}) => $apply(
    FieldCopyWithData({
      if (accuracyScore != null) #accuracyScore: accuracyScore,
      if (errorType != null) #errorType: errorType,
    }),
  );
  @override
  WordPronunciationAssessment $make(CopyWithData data) =>
      WordPronunciationAssessment(
        accuracyScore: data.get(#accuracyScore, or: $value.accuracyScore),
        errorType: data.get(#errorType, or: $value.errorType),
      );

  @override
  WordPronunciationAssessmentCopyWith<$R2, WordPronunciationAssessment, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _WordPronunciationAssessmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SyllableResultMapper extends ClassMapperBase<SyllableResult> {
  SyllableResultMapper._();

  static SyllableResultMapper? _instance;
  static SyllableResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyllableResultMapper._());
      SyllableAssessmentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SyllableResult';

  static String _$syllable(SyllableResult v) => v.syllable;
  static const Field<SyllableResult, String> _f$syllable = Field(
    'syllable',
    _$syllable,
    key: r'Syllable',
  );
  static SyllableAssessment _$pronunciationAssessment(SyllableResult v) =>
      v.pronunciationAssessment;
  static const Field<SyllableResult, SyllableAssessment>
  _f$pronunciationAssessment = Field(
    'pronunciationAssessment',
    _$pronunciationAssessment,
    key: r'PronunciationAssessment',
  );
  static int _$offset(SyllableResult v) => v.offset;
  static const Field<SyllableResult, int> _f$offset = Field(
    'offset',
    _$offset,
    key: r'Offset',
  );
  static int _$duration(SyllableResult v) => v.duration;
  static const Field<SyllableResult, int> _f$duration = Field(
    'duration',
    _$duration,
    key: r'Duration',
  );

  @override
  final MappableFields<SyllableResult> fields = const {
    #syllable: _f$syllable,
    #pronunciationAssessment: _f$pronunciationAssessment,
    #offset: _f$offset,
    #duration: _f$duration,
  };

  static SyllableResult _instantiate(DecodingData data) {
    return SyllableResult(
      syllable: data.dec(_f$syllable),
      pronunciationAssessment: data.dec(_f$pronunciationAssessment),
      offset: data.dec(_f$offset),
      duration: data.dec(_f$duration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SyllableResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyllableResult>(map);
  }

  static SyllableResult fromJson(String json) {
    return ensureInitialized().decodeJson<SyllableResult>(json);
  }
}

mixin SyllableResultMappable {
  String toJson() {
    return SyllableResultMapper.ensureInitialized().encodeJson<SyllableResult>(
      this as SyllableResult,
    );
  }

  Map<String, dynamic> toMap() {
    return SyllableResultMapper.ensureInitialized().encodeMap<SyllableResult>(
      this as SyllableResult,
    );
  }

  SyllableResultCopyWith<SyllableResult, SyllableResult, SyllableResult>
  get copyWith => _SyllableResultCopyWithImpl<SyllableResult, SyllableResult>(
    this as SyllableResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return SyllableResultMapper.ensureInitialized().stringifyValue(
      this as SyllableResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return SyllableResultMapper.ensureInitialized().equalsValue(
      this as SyllableResult,
      other,
    );
  }

  @override
  int get hashCode {
    return SyllableResultMapper.ensureInitialized().hashValue(
      this as SyllableResult,
    );
  }
}

extension SyllableResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SyllableResult, $Out> {
  SyllableResultCopyWith<$R, SyllableResult, $Out> get $asSyllableResult =>
      $base.as((v, t, t2) => _SyllableResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SyllableResultCopyWith<$R, $In extends SyllableResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  SyllableAssessmentCopyWith<$R, SyllableAssessment, SyllableAssessment>
  get pronunciationAssessment;
  $R call({
    String? syllable,
    SyllableAssessment? pronunciationAssessment,
    int? offset,
    int? duration,
  });
  SyllableResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SyllableResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyllableResult, $Out>
    implements SyllableResultCopyWith<$R, SyllableResult, $Out> {
  _SyllableResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyllableResult> $mapper =
      SyllableResultMapper.ensureInitialized();
  @override
  SyllableAssessmentCopyWith<$R, SyllableAssessment, SyllableAssessment>
  get pronunciationAssessment => $value.pronunciationAssessment.copyWith.$chain(
    (v) => call(pronunciationAssessment: v),
  );
  @override
  $R call({
    String? syllable,
    SyllableAssessment? pronunciationAssessment,
    int? offset,
    int? duration,
  }) => $apply(
    FieldCopyWithData({
      if (syllable != null) #syllable: syllable,
      if (pronunciationAssessment != null)
        #pronunciationAssessment: pronunciationAssessment,
      if (offset != null) #offset: offset,
      if (duration != null) #duration: duration,
    }),
  );
  @override
  SyllableResult $make(CopyWithData data) => SyllableResult(
    syllable: data.get(#syllable, or: $value.syllable),
    pronunciationAssessment: data.get(
      #pronunciationAssessment,
      or: $value.pronunciationAssessment,
    ),
    offset: data.get(#offset, or: $value.offset),
    duration: data.get(#duration, or: $value.duration),
  );

  @override
  SyllableResultCopyWith<$R2, SyllableResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SyllableResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SyllableAssessmentMapper extends ClassMapperBase<SyllableAssessment> {
  SyllableAssessmentMapper._();

  static SyllableAssessmentMapper? _instance;
  static SyllableAssessmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SyllableAssessmentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SyllableAssessment';

  static double _$accuracyScore(SyllableAssessment v) => v.accuracyScore;
  static const Field<SyllableAssessment, double> _f$accuracyScore = Field(
    'accuracyScore',
    _$accuracyScore,
    key: r'AccuracyScore',
  );

  @override
  final MappableFields<SyllableAssessment> fields = const {
    #accuracyScore: _f$accuracyScore,
  };

  static SyllableAssessment _instantiate(DecodingData data) {
    return SyllableAssessment(accuracyScore: data.dec(_f$accuracyScore));
  }

  @override
  final Function instantiate = _instantiate;

  static SyllableAssessment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SyllableAssessment>(map);
  }

  static SyllableAssessment fromJson(String json) {
    return ensureInitialized().decodeJson<SyllableAssessment>(json);
  }
}

mixin SyllableAssessmentMappable {
  String toJson() {
    return SyllableAssessmentMapper.ensureInitialized()
        .encodeJson<SyllableAssessment>(this as SyllableAssessment);
  }

  Map<String, dynamic> toMap() {
    return SyllableAssessmentMapper.ensureInitialized()
        .encodeMap<SyllableAssessment>(this as SyllableAssessment);
  }

  SyllableAssessmentCopyWith<
    SyllableAssessment,
    SyllableAssessment,
    SyllableAssessment
  >
  get copyWith =>
      _SyllableAssessmentCopyWithImpl<SyllableAssessment, SyllableAssessment>(
        this as SyllableAssessment,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SyllableAssessmentMapper.ensureInitialized().stringifyValue(
      this as SyllableAssessment,
    );
  }

  @override
  bool operator ==(Object other) {
    return SyllableAssessmentMapper.ensureInitialized().equalsValue(
      this as SyllableAssessment,
      other,
    );
  }

  @override
  int get hashCode {
    return SyllableAssessmentMapper.ensureInitialized().hashValue(
      this as SyllableAssessment,
    );
  }
}

extension SyllableAssessmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SyllableAssessment, $Out> {
  SyllableAssessmentCopyWith<$R, SyllableAssessment, $Out>
  get $asSyllableAssessment => $base.as(
    (v, t, t2) => _SyllableAssessmentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SyllableAssessmentCopyWith<
  $R,
  $In extends SyllableAssessment,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({double? accuracyScore});
  SyllableAssessmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SyllableAssessmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SyllableAssessment, $Out>
    implements SyllableAssessmentCopyWith<$R, SyllableAssessment, $Out> {
  _SyllableAssessmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SyllableAssessment> $mapper =
      SyllableAssessmentMapper.ensureInitialized();
  @override
  $R call({double? accuracyScore}) => $apply(
    FieldCopyWithData({
      if (accuracyScore != null) #accuracyScore: accuracyScore,
    }),
  );
  @override
  SyllableAssessment $make(CopyWithData data) => SyllableAssessment(
    accuracyScore: data.get(#accuracyScore, or: $value.accuracyScore),
  );

  @override
  SyllableAssessmentCopyWith<$R2, SyllableAssessment, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SyllableAssessmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PhonemeResultMapper extends ClassMapperBase<PhonemeResult> {
  PhonemeResultMapper._();

  static PhonemeResultMapper? _instance;
  static PhonemeResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhonemeResultMapper._());
      PhonemeAssessmentMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhonemeResult';

  static String _$phoneme(PhonemeResult v) => v.phoneme;
  static const Field<PhonemeResult, String> _f$phoneme = Field(
    'phoneme',
    _$phoneme,
    key: r'Phoneme',
  );
  static PhonemeAssessment _$pronunciationAssessment(PhonemeResult v) =>
      v.pronunciationAssessment;
  static const Field<PhonemeResult, PhonemeAssessment>
  _f$pronunciationAssessment = Field(
    'pronunciationAssessment',
    _$pronunciationAssessment,
    key: r'PronunciationAssessment',
  );
  static int _$offset(PhonemeResult v) => v.offset;
  static const Field<PhonemeResult, int> _f$offset = Field(
    'offset',
    _$offset,
    key: r'Offset',
  );
  static int _$duration(PhonemeResult v) => v.duration;
  static const Field<PhonemeResult, int> _f$duration = Field(
    'duration',
    _$duration,
    key: r'Duration',
  );

  @override
  final MappableFields<PhonemeResult> fields = const {
    #phoneme: _f$phoneme,
    #pronunciationAssessment: _f$pronunciationAssessment,
    #offset: _f$offset,
    #duration: _f$duration,
  };

  static PhonemeResult _instantiate(DecodingData data) {
    return PhonemeResult(
      phoneme: data.dec(_f$phoneme),
      pronunciationAssessment: data.dec(_f$pronunciationAssessment),
      offset: data.dec(_f$offset),
      duration: data.dec(_f$duration),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhonemeResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhonemeResult>(map);
  }

  static PhonemeResult fromJson(String json) {
    return ensureInitialized().decodeJson<PhonemeResult>(json);
  }
}

mixin PhonemeResultMappable {
  String toJson() {
    return PhonemeResultMapper.ensureInitialized().encodeJson<PhonemeResult>(
      this as PhonemeResult,
    );
  }

  Map<String, dynamic> toMap() {
    return PhonemeResultMapper.ensureInitialized().encodeMap<PhonemeResult>(
      this as PhonemeResult,
    );
  }

  PhonemeResultCopyWith<PhonemeResult, PhonemeResult, PhonemeResult>
  get copyWith => _PhonemeResultCopyWithImpl<PhonemeResult, PhonemeResult>(
    this as PhonemeResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return PhonemeResultMapper.ensureInitialized().stringifyValue(
      this as PhonemeResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhonemeResultMapper.ensureInitialized().equalsValue(
      this as PhonemeResult,
      other,
    );
  }

  @override
  int get hashCode {
    return PhonemeResultMapper.ensureInitialized().hashValue(
      this as PhonemeResult,
    );
  }
}

extension PhonemeResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhonemeResult, $Out> {
  PhonemeResultCopyWith<$R, PhonemeResult, $Out> get $asPhonemeResult =>
      $base.as((v, t, t2) => _PhonemeResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class PhonemeResultCopyWith<$R, $In extends PhonemeResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PhonemeAssessmentCopyWith<$R, PhonemeAssessment, PhonemeAssessment>
  get pronunciationAssessment;
  $R call({
    String? phoneme,
    PhonemeAssessment? pronunciationAssessment,
    int? offset,
    int? duration,
  });
  PhonemeResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PhonemeResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhonemeResult, $Out>
    implements PhonemeResultCopyWith<$R, PhonemeResult, $Out> {
  _PhonemeResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhonemeResult> $mapper =
      PhonemeResultMapper.ensureInitialized();
  @override
  PhonemeAssessmentCopyWith<$R, PhonemeAssessment, PhonemeAssessment>
  get pronunciationAssessment => $value.pronunciationAssessment.copyWith.$chain(
    (v) => call(pronunciationAssessment: v),
  );
  @override
  $R call({
    String? phoneme,
    PhonemeAssessment? pronunciationAssessment,
    int? offset,
    int? duration,
  }) => $apply(
    FieldCopyWithData({
      if (phoneme != null) #phoneme: phoneme,
      if (pronunciationAssessment != null)
        #pronunciationAssessment: pronunciationAssessment,
      if (offset != null) #offset: offset,
      if (duration != null) #duration: duration,
    }),
  );
  @override
  PhonemeResult $make(CopyWithData data) => PhonemeResult(
    phoneme: data.get(#phoneme, or: $value.phoneme),
    pronunciationAssessment: data.get(
      #pronunciationAssessment,
      or: $value.pronunciationAssessment,
    ),
    offset: data.get(#offset, or: $value.offset),
    duration: data.get(#duration, or: $value.duration),
  );

  @override
  PhonemeResultCopyWith<$R2, PhonemeResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhonemeResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PhonemeAssessmentMapper extends ClassMapperBase<PhonemeAssessment> {
  PhonemeAssessmentMapper._();

  static PhonemeAssessmentMapper? _instance;
  static PhonemeAssessmentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PhonemeAssessmentMapper._());
      NBestPhonemeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PhonemeAssessment';

  static double _$accuracyScore(PhonemeAssessment v) => v.accuracyScore;
  static const Field<PhonemeAssessment, double> _f$accuracyScore = Field(
    'accuracyScore',
    _$accuracyScore,
    key: r'AccuracyScore',
  );
  static List<NBestPhoneme>? _$nBestPhonemes(PhonemeAssessment v) =>
      v.nBestPhonemes;
  static const Field<PhonemeAssessment, List<NBestPhoneme>> _f$nBestPhonemes =
      Field('nBestPhonemes', _$nBestPhonemes, key: r'NBestPhonemes', opt: true);

  @override
  final MappableFields<PhonemeAssessment> fields = const {
    #accuracyScore: _f$accuracyScore,
    #nBestPhonemes: _f$nBestPhonemes,
  };

  static PhonemeAssessment _instantiate(DecodingData data) {
    return PhonemeAssessment(
      accuracyScore: data.dec(_f$accuracyScore),
      nBestPhonemes: data.dec(_f$nBestPhonemes),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PhonemeAssessment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PhonemeAssessment>(map);
  }

  static PhonemeAssessment fromJson(String json) {
    return ensureInitialized().decodeJson<PhonemeAssessment>(json);
  }
}

mixin PhonemeAssessmentMappable {
  String toJson() {
    return PhonemeAssessmentMapper.ensureInitialized()
        .encodeJson<PhonemeAssessment>(this as PhonemeAssessment);
  }

  Map<String, dynamic> toMap() {
    return PhonemeAssessmentMapper.ensureInitialized()
        .encodeMap<PhonemeAssessment>(this as PhonemeAssessment);
  }

  PhonemeAssessmentCopyWith<
    PhonemeAssessment,
    PhonemeAssessment,
    PhonemeAssessment
  >
  get copyWith =>
      _PhonemeAssessmentCopyWithImpl<PhonemeAssessment, PhonemeAssessment>(
        this as PhonemeAssessment,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return PhonemeAssessmentMapper.ensureInitialized().stringifyValue(
      this as PhonemeAssessment,
    );
  }

  @override
  bool operator ==(Object other) {
    return PhonemeAssessmentMapper.ensureInitialized().equalsValue(
      this as PhonemeAssessment,
      other,
    );
  }

  @override
  int get hashCode {
    return PhonemeAssessmentMapper.ensureInitialized().hashValue(
      this as PhonemeAssessment,
    );
  }
}

extension PhonemeAssessmentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PhonemeAssessment, $Out> {
  PhonemeAssessmentCopyWith<$R, PhonemeAssessment, $Out>
  get $asPhonemeAssessment => $base.as(
    (v, t, t2) => _PhonemeAssessmentCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PhonemeAssessmentCopyWith<
  $R,
  $In extends PhonemeAssessment,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    NBestPhoneme,
    NBestPhonemeCopyWith<$R, NBestPhoneme, NBestPhoneme>
  >?
  get nBestPhonemes;
  $R call({double? accuracyScore, List<NBestPhoneme>? nBestPhonemes});
  PhonemeAssessmentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PhonemeAssessmentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PhonemeAssessment, $Out>
    implements PhonemeAssessmentCopyWith<$R, PhonemeAssessment, $Out> {
  _PhonemeAssessmentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PhonemeAssessment> $mapper =
      PhonemeAssessmentMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    NBestPhoneme,
    NBestPhonemeCopyWith<$R, NBestPhoneme, NBestPhoneme>
  >?
  get nBestPhonemes => $value.nBestPhonemes != null
      ? ListCopyWith(
          $value.nBestPhonemes!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(nBestPhonemes: v),
        )
      : null;
  @override
  $R call({double? accuracyScore, Object? nBestPhonemes = $none}) => $apply(
    FieldCopyWithData({
      if (accuracyScore != null) #accuracyScore: accuracyScore,
      if (nBestPhonemes != $none) #nBestPhonemes: nBestPhonemes,
    }),
  );
  @override
  PhonemeAssessment $make(CopyWithData data) => PhonemeAssessment(
    accuracyScore: data.get(#accuracyScore, or: $value.accuracyScore),
    nBestPhonemes: data.get(#nBestPhonemes, or: $value.nBestPhonemes),
  );

  @override
  PhonemeAssessmentCopyWith<$R2, PhonemeAssessment, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _PhonemeAssessmentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class NBestPhonemeMapper extends ClassMapperBase<NBestPhoneme> {
  NBestPhonemeMapper._();

  static NBestPhonemeMapper? _instance;
  static NBestPhonemeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = NBestPhonemeMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'NBestPhoneme';

  static String _$phoneme(NBestPhoneme v) => v.phoneme;
  static const Field<NBestPhoneme, String> _f$phoneme = Field(
    'phoneme',
    _$phoneme,
    key: r'Phoneme',
  );
  static double _$score(NBestPhoneme v) => v.score;
  static const Field<NBestPhoneme, double> _f$score = Field(
    'score',
    _$score,
    key: r'Score',
  );

  @override
  final MappableFields<NBestPhoneme> fields = const {
    #phoneme: _f$phoneme,
    #score: _f$score,
  };

  static NBestPhoneme _instantiate(DecodingData data) {
    return NBestPhoneme(
      phoneme: data.dec(_f$phoneme),
      score: data.dec(_f$score),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static NBestPhoneme fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<NBestPhoneme>(map);
  }

  static NBestPhoneme fromJson(String json) {
    return ensureInitialized().decodeJson<NBestPhoneme>(json);
  }
}

mixin NBestPhonemeMappable {
  String toJson() {
    return NBestPhonemeMapper.ensureInitialized().encodeJson<NBestPhoneme>(
      this as NBestPhoneme,
    );
  }

  Map<String, dynamic> toMap() {
    return NBestPhonemeMapper.ensureInitialized().encodeMap<NBestPhoneme>(
      this as NBestPhoneme,
    );
  }

  NBestPhonemeCopyWith<NBestPhoneme, NBestPhoneme, NBestPhoneme> get copyWith =>
      _NBestPhonemeCopyWithImpl<NBestPhoneme, NBestPhoneme>(
        this as NBestPhoneme,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return NBestPhonemeMapper.ensureInitialized().stringifyValue(
      this as NBestPhoneme,
    );
  }

  @override
  bool operator ==(Object other) {
    return NBestPhonemeMapper.ensureInitialized().equalsValue(
      this as NBestPhoneme,
      other,
    );
  }

  @override
  int get hashCode {
    return NBestPhonemeMapper.ensureInitialized().hashValue(
      this as NBestPhoneme,
    );
  }
}

extension NBestPhonemeValueCopy<$R, $Out>
    on ObjectCopyWith<$R, NBestPhoneme, $Out> {
  NBestPhonemeCopyWith<$R, NBestPhoneme, $Out> get $asNBestPhoneme =>
      $base.as((v, t, t2) => _NBestPhonemeCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class NBestPhonemeCopyWith<$R, $In extends NBestPhoneme, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? phoneme, double? score});
  NBestPhonemeCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _NBestPhonemeCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, NBestPhoneme, $Out>
    implements NBestPhonemeCopyWith<$R, NBestPhoneme, $Out> {
  _NBestPhonemeCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<NBestPhoneme> $mapper =
      NBestPhonemeMapper.ensureInitialized();
  @override
  $R call({String? phoneme, double? score}) => $apply(
    FieldCopyWithData({
      if (phoneme != null) #phoneme: phoneme,
      if (score != null) #score: score,
    }),
  );
  @override
  NBestPhoneme $make(CopyWithData data) => NBestPhoneme(
    phoneme: data.get(#phoneme, or: $value.phoneme),
    score: data.get(#score, or: $value.score),
  );

  @override
  NBestPhonemeCopyWith<$R2, NBestPhoneme, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _NBestPhonemeCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

