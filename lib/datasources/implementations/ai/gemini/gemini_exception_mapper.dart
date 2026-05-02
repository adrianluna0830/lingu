import 'dart:async';
import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/domain/interfaces/ai/ai_exception.dart';

class GeminiExceptionMapper {
  static AIException map(Object e) {
    return switch (e) {
      AuthenticationException() => const AIAuthException(),
      RateLimitException(:final retryAfter) => AIRateLimitException(retryAfter: retryAfter),
      ValidationException(:final message) => AIInvalidRequestException(message),
      ApiException(:final message) => AIInvalidRequestException(message),
      TimeoutException() => const AINetworkException('Timeout: sin conexión o red lenta'),
      AbortedException() => const AINetworkException('Request cancelado'),
      _ => AIUnknownException(e.toString()),
    };
  }
}