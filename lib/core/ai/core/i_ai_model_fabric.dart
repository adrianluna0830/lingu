import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/credential_results.dart';
abstract class IAIModelFabric
{
  Future<CredentialValidationResult> validate();
  IAIModel create();
}
