import 'package:hive_ce/hive_ce.dart';
import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/topics/topic.dart';

@GenerateAdapters([
  AdapterSpec<Topic>(),
  AdapterSpec<TopicData>(),
  AdapterSpec<CEFR>(),
  AdapterSpec<LanguageLocale>(),
  AdapterSpec<TopicStatus>(),
])
part 'hive_adapters.g.dart';
