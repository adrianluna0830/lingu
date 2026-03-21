import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/features/chat/logic/feedback/feedback_correction_level.dart';

class UserFeedbackAnalyzer
{
  final IAIModel aiModel;
   
  UserFeedbackAnalyzer(this.aiModel);


  Future<(UserFeedback? fluency, UserFeedback? grammar)> analyze(String statement) async
  {
    aiModel.generateContent(prompt: "");
    return (null, null);
  }

}