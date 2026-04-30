sealed class CredentialValidationResult {}

class CredentialValid extends CredentialValidationResult {}

class CredentialInvalid extends CredentialValidationResult {
  final String reason;
  CredentialInvalid(this.reason);
}

class CredentialNetworkError extends CredentialValidationResult {}