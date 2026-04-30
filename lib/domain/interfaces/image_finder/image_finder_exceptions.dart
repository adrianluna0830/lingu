sealed class ImageFinderException implements Exception {
  final String message;
  const ImageFinderException(this.message);
}

class NetworkException extends ImageFinderException {
  final int? statusCode;
  const NetworkException(super.message, {this.statusCode});
}

class NoResultsException extends ImageFinderException {
  const NoResultsException(super.message);
}

class DownloadException extends ImageFinderException {
  final int? statusCode;
  const DownloadException(super.message, {this.statusCode});
}

class ParseException extends ImageFinderException {
  const ParseException(super.message);
}

class RequestTimeoutException extends ImageFinderException {
  const RequestTimeoutException(super.message);
}