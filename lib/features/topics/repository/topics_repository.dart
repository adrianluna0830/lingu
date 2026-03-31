import 'package:hive_ce/hive_ce.dart';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/topics/topic.dart';

@singleton
class TopicDataRepository {
  final Box<TopicData> _box;

  TopicDataRepository(this._box);

  @factoryMethod
  @preResolve
  static Future<TopicDataRepository> create() async {
    final box = await Hive.openBox<TopicData>('topic_data');
    return TopicDataRepository(box);
  }

  Future<void> put(TopicData topicData) async {
    await _box.put(topicData.id, topicData);
  }

  Future<void> delete(dynamic topicDataId) async {
    await _box.delete(topicDataId.toString());
  }

  Future<void> deleteAll() async {
    await _box.clear();
  }

  Future<TopicData?> getByTopicId(dynamic topicId) async {
    return _box.get(topicId.toString());
  }

  Future<List<TopicData>> getAll() async {
    return _box.values.toList();
  }

  Future<TopicData?> get(dynamic topicId) async {
    return _box.get(topicId.toString());
  }
}
