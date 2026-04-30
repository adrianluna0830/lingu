
import 'package:hive_ce/hive_ce.dart';
import 'package:lingu/domain/word/repositories/i_word_repository.dart';
import 'package:lingu/domain/word/models/word.dart';

class HiveWordRepository<T extends Word> implements IWordRepository {
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
