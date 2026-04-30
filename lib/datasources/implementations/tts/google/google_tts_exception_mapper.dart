
import 'package:googleapis/spanner/v1.dart';
import 'package:lingu/domain/interfaces/tts/tts_exceptions.dart';

class GoogleTTSExceptionMapper {
  static TTSException map(Object e) {
    return switch (e) {
      DetailedApiRequestError(:final status, :final message) => switch (status) {
        401 || 403 => TTSAuthException(message ?? 'Sin permisos'),
        429       => TTSRateLimitException(),
        400       => TTSInvalidRequestException(message ?? 'Petición inválida'),
        _         => TTSUnknownException(message ?? e.toString()),
      },
      ApiRequestError(:final message) => TTSUnknownException(message ?? e.toString()),
      _ => TTSUnknownException(e.toString()),
    };
  }
}