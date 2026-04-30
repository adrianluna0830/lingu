import 'package:lingu/domain/word/models/word.dart';

abstract class IWordRepository {
  Future<void> put(Word word);
  Future<Word?> get(String word);
  Future<List<Word>> getAll();
  Future<void> delete(String word);
}
