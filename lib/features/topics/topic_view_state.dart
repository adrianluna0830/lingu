import 'package:lingu/core/models/cefr.dart';

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
  EditingState(this.index, this.title, this.subtitle, this.description, this.level);
}
class AddTopicState extends TopicViewState {}
