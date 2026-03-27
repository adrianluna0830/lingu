import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart';

@injectable
class PronunciationFeedbackService {
  Future<PronunciationFeedback> getFeedback(String audioUrl) async {
    throw UnimplementedError('PronunciationFeedbackService.getFeedback no está implementado aún.');
  }
}
