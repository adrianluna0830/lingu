sealed class MessageDetails
{

}
class UserTextMessageFeedback extends MessageDetails
{
  final String? feedback;
  UserTextMessageFeedback(this.feedback);
}
class UserAudioMessageFeedback extends MessageDetails
{
  final String? feedback;
  UserAudioMessageFeedback(this.feedback);
}
