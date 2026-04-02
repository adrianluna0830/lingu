import 'package:http/http.dart' as http;

class ApiKeyClient extends http.BaseClient {
  final String _apiKey;
  final http.Client _inner = http.Client();

  ApiKeyClient(this._apiKey);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final url = request.url.replace(
      queryParameters: {
        ...request.url.queryParameters,
        'key': _apiKey,
      },
    );

    final newRequest = http.Request(request.method, url)
      ..headers.addAll(request.headers)
      ..bodyBytes = (request as http.Request).bodyBytes;

    return _inner.send(newRequest);
  }

  @override
  void close() => _inner.close();
}