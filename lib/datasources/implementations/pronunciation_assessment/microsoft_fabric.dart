import 'dart:async';
import 'dart:io';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/settings/services/microsoft_settings_service.dart';

class MicrosoftFabric implements IAPIFabric<void> {
  final MicrosoftSettingsService _settings;

  MicrosoftFabric(this._settings);

  @override
  Future<void> create() async {
    // This fabric doesn't create a single service, 
    // it's used for validation of Microsoft credentials.
  }

  @override
  Future<CredentialValidationResult> validate() async {
    final apiKey = _settings.apiKey.value;
    final region = _settings.region.value;

    if (apiKey == null || apiKey.isEmpty || region == null || region.isEmpty) {
      return CredentialInvalid('Microsoft API Key and Region are required');
    }

    try {
      final client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 10);

      // Use the region to construct a validation endpoint
      final endpoint = 'https://$region.api.cognitive.microsoft.com';
      final uri = Uri.parse(
        '$endpoint/speechtotext/endpoints?api-version=2024-11-15&top=1',
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
          return CredentialInvalid('Access forbidden. Check your subscription permissions.');
        case 404:
          return CredentialInvalid('Endpoint not found. Verify the region.');
        default:
          return CredentialInvalid('Unexpected response: ${response.statusCode}.');
      }
    } catch (e) {
      return CredentialInvalid('Network error or invalid region.');
    }
  }
}
