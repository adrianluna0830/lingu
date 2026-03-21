
import 'package:injectable/injectable.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/features/chat/logic/message/chat_message.dart';
import 'package:lingu/features/chat/logic/message/feedback_correction_level.dart';
import 'package:signals/signals.dart';

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
@singleton
class ChatMessagesManager
{

  final _messages = listSignal<ChatMessage>([]);
  ReadonlySignal<List<ChatMessage>> get messages => _messages;

  Future<void> addTextMessage({required String text}) async
  {

      _messages.add(UserTextMessage(text: text));
  

  }

  Future<void> addAudioMessage({required String audioUrl, required Duration duration}) async
  {

      _messages.add(UserAudioMessage(audioUrl: audioUrl, duration: duration));

  }
}
