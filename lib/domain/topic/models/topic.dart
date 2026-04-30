import 'package:lingu/domain/core/models/cefr.dart';
import 'package:lingu/domain/core/models/language_locale.dart';

class Topic {
  final LanguageLocale language;
  final String title;
  final String? subtitle;
  final String? description;
  final CEFR? level;
  String get id => '$language-$title';

  Topic({
    required this.language,
    required this.title,
    this.subtitle,
    this.description,
    this.level,
  });
}


enum TopicStatus {
  normal,
  disabled,
  mastered,
  prioritized,
}

class TopicData {
  final Topic topic;
  final int order;
  final List<double> scoresNormalized;
  final TopicStatus status;

  String get id => topic.id;

  const TopicData({
    required this.topic,
    required this.order,
    this.scoresNormalized = const [],
    this.status = TopicStatus.normal,
  });
}
