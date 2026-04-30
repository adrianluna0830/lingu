sealed class PronunciationAssessmentCreationError {
  final String message;
  const PronunciationAssessmentCreationError(this.message);

  @override
  String toString() => message;
}

final class InvalidParametersError extends PronunciationAssessmentCreationError {
  const InvalidParametersError(super.message);
}

final class ServiceCreationError extends PronunciationAssessmentCreationError {
  const ServiceCreationError(super.message);
}

final class InitializationTimeoutError extends PronunciationAssessmentCreationError {
  const InitializationTimeoutError(super.message);
}


sealed class PronunciationAssessmentUsageError {
  final String message;
  const PronunciationAssessmentUsageError(this.message);

  @override
  String toString() => message;
}

final class ServiceNotInitializedError extends PronunciationAssessmentUsageError {
  const ServiceNotInitializedError() : super('Service not initialized');
}

final class EvaluationInProgressError extends PronunciationAssessmentUsageError {
  const EvaluationInProgressError()
      : super('An evaluation is already in progress. Please wait until it is finished.');
}

final class InvalidAudioError extends PronunciationAssessmentUsageError {
  const InvalidAudioError(super.message);
}

final class AssessmentError extends PronunciationAssessmentUsageError {
  const AssessmentError(super.message);
}

final class AssessmentTimeoutError extends PronunciationAssessmentUsageError {
  const AssessmentTimeoutError(super.message);
}

final class AuthenticationError extends PronunciationAssessmentUsageError {
  const AuthenticationError(super.message);
}

final class NetworkError extends PronunciationAssessmentUsageError {
  const NetworkError(super.message);
}

final class NoSpeechError extends PronunciationAssessmentUsageError {
  const NoSpeechError() : super('No speech was recognized. Please check your microphone and try again.');
}

final class QuotaExceededError extends PronunciationAssessmentUsageError {
  const QuotaExceededError(super.message);
}

final class InternalServiceError extends PronunciationAssessmentUsageError {
  const InternalServiceError(super.message);
}