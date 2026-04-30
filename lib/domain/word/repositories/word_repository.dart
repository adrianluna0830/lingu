import 'package:hive_ce/hive_ce.dart';
import 'package:lingu/domain/word/repositories/hive_word_repository.dart';
import 'package:lingu/domain/word/models/word.dart';

class EnglishWordRepository extends HiveWordRepository<EnglishWord> {
  EnglishWordRepository(super.box);

  static Future<EnglishWordRepository> create() async {
    final box = await Hive.openBox<EnglishWord>('english_word_box');
    return EnglishWordRepository(box);
  }
}

class GermanWordRepository extends HiveWordRepository<GermanWord> {
  GermanWordRepository(super.box);

  static Future<GermanWordRepository> create() async {
    final box = await Hive.openBox<GermanWord>('german_word_box');
    return GermanWordRepository(box);
  }
}

class SpanishWordRepository extends HiveWordRepository<SpanishWord> {
  SpanishWordRepository(super.box);

  static Future<SpanishWordRepository> create() async {
    final box = await Hive.openBox<SpanishWord>('spanish_word_box');
    return SpanishWordRepository(box);
  }
}
