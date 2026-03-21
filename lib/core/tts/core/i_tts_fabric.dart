import 'package:lingu/core/credential_results.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';

abstract class ITTSFabric
{
  Future<CredentialValidationResult> validate();
  ITextToSpeechService create();
}