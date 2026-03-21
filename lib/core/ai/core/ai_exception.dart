sealed class AIException implements Exception {
  const AIException();
  String get message;
}

class AIAuthException extends AIException {
  @override
  final String message;
  const AIAuthException([this.message = 'API key inválida o expirada']);
}

class AIRateLimitException extends AIException {
  @override
  final String message;
  final DateTime? retryAfter;
  const AIRateLimitException({
    this.message = 'Límite de requests alcanzado',
    this.retryAfter,
  });
}

class AINetworkException extends AIException {
  @override
  final String message;
  const AINetworkException([this.message = 'Error de conexión']);
}

class AIInvalidRequestException extends AIException {
  @override
  final String message;
  const AIInvalidRequestException([this.message = 'Petición inválida']);
}

class AIUnknownException extends AIException {
  @override
  final String message;
  const AIUnknownException([this.message = 'Error desconocido']);
}