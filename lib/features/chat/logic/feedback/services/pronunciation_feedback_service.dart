import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback_result.dart';

@Scope('chat')
@lazySingleton
class PronunciationFeedbackService {
  Future<PronunciationFeedbackResult> getFeedback(String audioUrl) async {
    throw UnimplementedError('PronunciationFeedbackService.getFeedback no está implementado aún.');
  }
}
