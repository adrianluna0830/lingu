sealed class TTSException implements Exception {
  const TTSException();
  String get message;
}

class TTSAuthException extends TTSException {
  @override
  final String message;
  const TTSAuthException([this.message = 'API key inválida o sin permisos']);
}

class TTSRateLimitException extends TTSException {
  @override
  String get message => 'Límite de requests alcanzado';
  const TTSRateLimitException();
}

class TTSInvalidRequestException extends TTSException {
  @override
  final String message;
  const TTSInvalidRequestException([this.message = 'Petición inválida']);
}

class TTSNetworkException extends TTSException {
  @override
  final String message;
  const TTSNetworkException([this.message = 'Error de conexión']);
}

class TTSUnknownException extends TTSException {
  @override
  final String message;
  const TTSUnknownException([this.message = 'Error desconocido']);
}