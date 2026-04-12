import 'dart:math';

import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';

sealed class MessageFeedbackSummary {
  final FeedbackResultEnum grammar;
  final FeedbackResultEnum fluency;
  final String? translation;

  const MessageFeedbackSummary({
    required this.grammar,
    required this.fluency,
    this.translation,
  });

  FeedbackResultEnum get mostSevere;
}

class TextFeedbackSummary extends MessageFeedbackSummary {
  const TextFeedbackSummary({
    required super.grammar,
    required super.fluency,
    super.translation,
  });

  @override
  FeedbackResultEnum get mostSevere {
    final maxIndex = max(grammar.index, fluency.index);
    return FeedbackResultEnum.values[maxIndex];
  }
}

class AudioFeedbackSummary extends MessageFeedbackSummary {
  final FeedbackResultEnum pronunciation;

  const AudioFeedbackSummary({
    required super.grammar,
    required super.fluency,
    required this.pronunciation,
    super.translation,
  });

  @override
  FeedbackResultEnum get mostSevere {
    final maxIndex = [grammar.index, fluency.index, pronunciation.index].reduce(max);
    return FeedbackResultEnum.values[maxIndex];
  }
}
