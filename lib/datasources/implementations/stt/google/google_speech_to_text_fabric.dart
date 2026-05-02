import 'dart:async';
import 'dart:io';

import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/settings/services/stt_credentials_service.dart';
import 'package:lingu/datasources/implementations/stt/google/google_speech_to_text_service.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';

class GoogleSpeechToTextFabric implements IAPIFabric<ISpeechToTextService> {
  final STTCredentialsService _credentialsService;

  GoogleSpeechToTextFabric(this._credentialsService);

  @override
  Future<CredentialValidationResult> validate() async {
    final apiKey = _credentialsService.apiKey.value;
    if (apiKey == null || apiKey.isEmpty) {
      return CredentialInvalid('API key vacía');
    }

    final client = clientViaApiKey(apiKey);

    try {
      final speechApi = SpeechApi(client);
      await speechApi.operations.list(pageSize: 1);
      return CredentialValid();
    } on DetailedApiRequestError catch (e) {
      switch (e.status) {
        case 401:
          return CredentialInvalid('Invalid or unauthorized API key.');
        case 403:
          return CredentialInvalid(
            'Access forbidden. Check your subscription permissions.',
          );
        case 404:
          return CredentialInvalid(
            'Endpoint not found. Verify the resource URL.',
          );
        default:
          return CredentialInvalid('Unexpected response: ${e.status}.');
      }
    } on ApiRequestError catch (e) {
      return CredentialInvalid('API error: ${e.message}');
    } on SocketException {
      return CredentialNetworkError();
    } on TimeoutException {
      return CredentialNetworkError();
    } catch (_) {
      return CredentialNetworkError();
    } finally {
      client.close();
    }
  }

  @override
  Future<ISpeechToTextService> create() async {
    final apiKey = _credentialsService.apiKey.value!;
    final client = clientViaApiKey(apiKey);
    final speechApi = SpeechApi(client);

    return GoogleSpeechToTextService(speechApi);
  }
}
