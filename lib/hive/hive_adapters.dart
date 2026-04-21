import 'package:hive_ce/hive_ce.dart';
import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/core/models/grammatical_gender.dart';
import 'package:lingu/features/topics/topic.dart';
import 'package:lingu/core/word/word.dart';
import 'package:lingu/core/word/english_word_details.dart';
import 'package:lingu/core/word/german_word_details.dart';
import 'package:lingu/core/word/spanish_word_details.dart';

@GenerateAdapters([
  AdapterSpec<Topic>(),
  AdapterSpec<TopicData>(),
  AdapterSpec<CEFR>(),
  AdapterSpec<LanguageLocale>(),
  AdapterSpec<TopicStatus>(),
  AdapterSpec<PartOfSpeech>(),
  AdapterSpec<WordExample>(),
  AdapterSpec<GrammaticalGender>(),
  AdapterSpec<EnglishWordDetails>(),
  AdapterSpec<GermanWordDetails>(),
  AdapterSpec<VerbConjugationType>(),
  AdapterSpec<SpanishWordDetails>(),
  AdapterSpec<WordMeaning>(),
  AdapterSpec<EnglishWord>(),
  AdapterSpec<GermanWord>(),
  AdapterSpec<SpanishWord>(),
])
part 'hive_adapters.g.dart';
