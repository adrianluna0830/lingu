import 'package:injectable/injectable.dart';
import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/features/topics/topic.dart';
import 'package:lingu/features/topics/topic_view_state.dart';
import 'package:lingu/features/topics/topics_view.dart';
import 'package:signals/signals_flutter.dart';

@injectable
class TopicsManager {
  final _state = signal<TopicViewState>(IdleState());
  ReadonlySignal<TopicViewState> get state => _state;

  final _topics = listSignal<Topic>([
    Topic(title: 'Greetings', subtitle: 'Basic hello and goodbye', level: CEFR.a1),
    Topic(title: 'Food', subtitle: 'Ordering at a restaurant', level: CEFR.a2),
    Topic(title: 'Travel', subtitle: 'Asking for directions', level: CEFR.b1),
    Topic(title: 'Work', subtitle: 'Professional conversations', level: CEFR.b2),
  ]);
  ReadonlySignal<List<Topic>> get topics => _topics;

  void enableAdding() => _state.value = AddTopicState();

  void add(String title, String? subtitle, String? description, CEFR? level) {
    _topics.add(Topic(title: title, subtitle: subtitle, description: description, level: level));
    _state.value = IdleState();
  }

  void enableDeleting() => _state.value = DeletingState();
  void enableReordering() => _state.value = ReorderingState();

  void delete(List<int> indices) {
    indices.sort((a, b) => b.compareTo(a));
    for (final i in indices) _topics.removeAt(i);
    _state.value = IdleState();
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final topic = _topics.removeAt(oldIndex);
    _topics.insert(newIndex, topic);
  }

  void showEdit(int index) {
    final topic = _topics[index];
    _state.value = EditingState(index, topic.title, topic.subtitle, topic.description, topic.level);
  }

  void saveEdit(int index, String title, String? subtitle, String? description, CEFR? level) {
    _topics[index] = Topic(title: title, subtitle: subtitle, description: description, level: level);
    _state.value = IdleState();
  }

  void close() => _state.value = IdleState();
}
