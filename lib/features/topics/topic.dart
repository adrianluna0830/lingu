import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/core/models/language_locale.dart';

class Topic {
  final String title;
  final String? subtitle;
  final String? description;
  final CEFR? level;

  Topic({
    required this.title,
    this.subtitle,
    this.description,
    this.level,
  });
}

class TopicList {
  final LanguageLocale language;
  final List<Topic> topics;
  TopicList(this.language, this.topics);
}
