import 'package:hive_ce/hive_ce.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/domain/core/models/cefr.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/word/models/grammatical_gender.dart';
import 'package:lingu/domain/topic/models/topic.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:lingu/domain/word/models/details/english_word_details.dart';
import 'package:lingu/domain/word/models/details/german_word_details.dart';
import 'package:lingu/domain/word/models/details/spanish_word_details.dart';

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
  AdapterSpec<WordImage>(),
  AdapterSpec<WordMeaning>(),
  AdapterSpec<EnglishWord>(),
  AdapterSpec<GermanWord>(),
  AdapterSpec<SpanishWord>(),
])
part 'hive_adapters.g.dart';
