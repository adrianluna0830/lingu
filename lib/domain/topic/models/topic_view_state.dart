import 'package:lingu/domain/core/models/cefr.dart';
import 'package:lingu/domain/topic/models/topic.dart';

sealed class TopicViewState {}
class IdleState extends TopicViewState {}
class DeletingState extends TopicViewState {}
class ReorderingState extends TopicViewState {}
class EditingState extends TopicViewState {
  final int index;
  final String title;
  final String? subtitle;
  final String? description;
  final CEFR? level;
  final TopicStatus status;
  EditingState(this.index, this.title, this.subtitle, this.description, this.level, this.status);
}
class AddTopicState extends TopicViewState {}
