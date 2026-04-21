import 'package:hive_ce/hive_ce.dart';
import 'package:lingu/core/word/word.dart';

sealed class WordRepository {
  Future<void> put(Word word);
  Future<Word?> get(String word);
  Future<List<Word>> getAll();
  Future<void> delete(String word);
}

class HiveWordRepository<T extends Word> implements WordRepository {
  final Box<T> box;

  HiveWordRepository(this.box);

  @override
  Future<void> put(Word word) async {
    await box.put(word.word.toLowerCase(), word as T);
  }

  @override
  Future<Word?> get(String word) async {
    return box.get(word.toLowerCase());
  }

  @override
  Future<List<Word>> getAll() async {
    return box.values.toList();
  }

  @override
  Future<void> delete(String word) async {
    await box.delete(word.toLowerCase());
  }
}

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
