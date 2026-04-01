import 'package:lingu/core/models/credential_results.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/tts/core/i_text_to_speech_service.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';

abstract class IAPIFabric<T> {
  Future<CredentialValidationResult> validate();
  Future<T> create();
}

abstract class IAIFabric implements IAPIFabric<IAIService> {}
abstract class ITTSFabric implements IAPIFabric<ITextToSpeechService> {}
abstract class IPronunciationAssessmentFabric implements IAPIFabric<IPronunciationAssessmentService> {}