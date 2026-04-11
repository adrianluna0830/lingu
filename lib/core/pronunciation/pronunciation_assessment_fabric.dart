import 'dart:async';
import 'dart:io';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/models/credential_results.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/pronunciation/service/linux/linux_pronunciation_assessment_service.dart';
import 'package:lingu/core/pronunciation/service/mobile_windows_mac_pronunciation/web_pronunciation_assessment_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';

class PronunciationAssessmentFabric implements IPronunciationAssessmentFabric {
  final PronunciationAssessmentCredentialsService _credentialsService;

  PronunciationAssessmentFabric(this._credentialsService);

  @override
  Future<IPronunciationAssessmentService> create() async {
    assert(
      _credentialsService.endpoint.value != null,
      'Endpoint must not be null before calling create().',
    );
    assert(
      _credentialsService.apiKey.value != null,
      'API key must not be null before calling create().',
    );

    final endpoint = _credentialsService.endpoint.value!;
    final apiKey = _credentialsService.apiKey.value!;

    if (Platform.isLinux) {
      return await LinuxPronunciationAssessmentService.create(
        speechKey: apiKey,
        speechEndpoint: endpoint,
      );
    } else {
      return await WebViewPronunciationAssessmentService.create(
        subscriptionKey: apiKey,
        endpoint: endpoint,
      );
    }
  }

  @override
  Future<CredentialValidationResult> validate() async {
    final endpoint = _credentialsService.endpoint.value!;
    final apiKey = _credentialsService.apiKey.value!;

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      final uri = Uri.parse(
        '$endpoint/speechtotext/endpoints?api-version=2025-10-15&top=1',
      );

      final request = await client
          .getUrl(uri)
          .timeout(const Duration(seconds: 10));

      request.headers.set('Ocp-Apim-Subscription-Key', apiKey);

      final response = await request.close().timeout(
        const Duration(seconds: 10),
      );

      client.close();

      switch (response.statusCode) {
        case 200:
          return CredentialValid();
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
          return CredentialInvalid(
            'Unexpected response: ${response.statusCode}.',
          );
      }
    } on SocketException {
      return CredentialNetworkError();
    } on TimeoutException {
      return CredentialNetworkError();
    } catch (_) {
      return CredentialNetworkError();
    }
  }
}