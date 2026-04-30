import 'package:lingu/domain/core/models/cefr.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/settings/services/locale_settings_service.dart';
import 'package:lingu/domain/topic/repositories/topics_repository.dart';
import 'package:lingu/domain/topic/models/topic.dart';
import 'package:lingu/domain/topic/models/topic_view_state.dart';
import 'package:signals/signals_flutter.dart';

class TopicsManager {
  final TopicDataRepository _repository;
  final LocaleSettingsService _localeSettings;

  final _state = signal<TopicViewState>(IdleState());
  ReadonlySignal<TopicViewState> get state => _state;

  final _topics = listSignal<TopicData>([]);
  
  late final filteredTopics = computed(() {
    final language = _localeSettings.learningLocale.value;
    return _topics.value.where((t) => t.topic.language == language).toList();
  });

  TopicsManager(this._repository, this._localeSettings) {
    _init();
  }

  Future<void> _init() async {
    await _loadTopics();
  }

  Future<void> _loadTopics() async {
    final storedTopics = await _repository.getAll();
    storedTopics.sort((a, b) => a.order.compareTo(b.order));
    _topics.value = storedTopics;
  }

  void enableAdding() => _state.value = AddTopicState();

  Future<void> add(String title, String? subtitle, String? description, CEFR? level, TopicStatus status) async {
    final language = _localeSettings.learningLocale.value ?? LanguageLocale.en;
    final topic = Topic(
      language: language,
      title: title,
      subtitle: subtitle,
      description: description,
      level: level,
    );
    final topicData = TopicData(
      topic: topic,
      order: _topics.length,
      status: status,
    );
    await _repository.put(topicData);
    _topics.add(topicData);
    _state.value = IdleState();
  }

  void enableDeleting() => _state.value = DeletingState();
  void enableReordering() => _state.value = ReorderingState();

  Future<void> delete(List<int> filteredIndices) async {
    final topicsToDelete = filteredIndices.map((i) => filteredTopics.value[i]).toList();
    
    for (final data in topicsToDelete) {
      await _repository.delete(data.id);
      _topics.removeWhere((t) => t.id == data.id);
    }

    for (int i = 0; i < _topics.length; i++) {
      if (_topics[i].order != i) {
        final updated = TopicData(
          topic: _topics[i].topic,
          order: i,
          scoresNormalized: _topics[i].scoresNormalized,
          status: _topics[i].status,
        );
        _topics[i] = updated;
        await _repository.put(updated);
      }
    }

    _state.value = IdleState();
  }

  Future<void> bulkUpdateStatus(List<int> filteredIndices, TopicStatus newStatus) async {
    final topicsToUpdate = filteredIndices.map((i) => filteredTopics.value[i]).toList();

    for (final data in topicsToUpdate) {
      final newData = TopicData(
        topic: data.topic,
        order: data.order,
        scoresNormalized: data.scoresNormalized,
        status: newStatus,
      );

      final masterIndex = _topics.indexWhere((t) => t.id == data.id);
      _topics[masterIndex] = newData;
      await _repository.put(newData);
    }
    _state.value = IdleState();
  }

  Future<void> reorder(int oldFilteredIndex, int newFilteredIndex) async {
    final filteredList = List<TopicData>.from(filteredTopics.value);
    
    if (newFilteredIndex > oldFilteredIndex) newFilteredIndex--;
    final movedTopic = filteredList.removeAt(oldFilteredIndex);
    filteredList.insert(newFilteredIndex, movedTopic);

    for (int i = 0; i < filteredList.length; i++) {
      final oldData = filteredList[i];
      final newData = TopicData(
        topic: oldData.topic,
        order: i, 
        scoresNormalized: oldData.scoresNormalized,
        status: oldData.status,
      );
      
      final masterIndex = _topics.indexWhere((t) => t.id == oldData.id);
      _topics[masterIndex] = newData;
      await _repository.put(newData);
    }
    
    _topics.sort((a, b) => a.order.compareTo(b.order));
    for (int i = 0; i < _topics.length; i++) {
      if (_topics[i].order != i) {
        final updated = TopicData(
          topic: _topics[i].topic,
          order: i,
          scoresNormalized: _topics[i].scoresNormalized,
          status: _topics[i].status,
        );
        _topics[i] = updated;
        await _repository.put(updated);
      }
    }
  }

  void showEdit(int filteredIndex) {
    final data = filteredTopics.value[filteredIndex];
    _state.value = EditingState(filteredIndex, data.topic.title, data.topic.subtitle, data.topic.description, data.topic.level, data.status);
  }

  Future<void> saveEdit(int filteredIndex, String title, String? subtitle, String? description, CEFR? level, TopicStatus status) async {
    final oldData = filteredTopics.value[filteredIndex];
    final newTopic = Topic(
      language: oldData.topic.language,
      title: title,
      subtitle: subtitle,
      description: description,
      level: level,
    );

    final newData = TopicData(
      topic: newTopic,
      order: oldData.order,
      scoresNormalized: oldData.scoresNormalized,
      status: status,
    );

    final masterIndex = _topics.indexWhere((t) => t.id == oldData.id);

    if (oldData.id != newData.id) {
      await _repository.delete(oldData.id);
    }
    await _repository.put(newData);
    _topics[masterIndex] = newData;
    _state.value = IdleState();
  }

  void close() => _state.value = IdleState();
}
