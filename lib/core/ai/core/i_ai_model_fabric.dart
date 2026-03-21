import 'package:lingu/core/ai/core/i_ai_model.dart';
abstract class IAIModelFabric
{
  Future<CredentialValidationResult> validate();
  IAIModel create();
}
sealed class CredentialValidationResult {}

class CredentialValid extends CredentialValidationResult {}

class CredentialInvalid extends CredentialValidationResult {
  final String reason;
  CredentialInvalid(this.reason);
}

class CredentialNetworkError extends CredentialValidationResult {}