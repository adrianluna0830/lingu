import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingu/datasources/implementations/ai/open_router/open_router_ai_service.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/settings/services/open_router_settings_service.dart';

class OpenRouterFabric implements IAPIFabric<IAIService> {
  final OpenRouterSettingsService _settings;

  OpenRouterFabric(this._settings);

  @override
  Future<IAIService> create() async {
    final apiKey = _settings.apiKey.value;
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenRouter API Key not configured');
    }
    return OpenRouterAiService(apiKey: apiKey);
  }

  @override
  Future<CredentialValidationResult> validate() async {
    final apiKey = _settings.apiKey.value;
    if (apiKey == null || apiKey.isEmpty) {
      return CredentialInvalid('OpenRouter API Key is required');
    }

    try {
      final response = await http.get(
        Uri.parse('https://openrouter.ai/api/v1/auth/key'),
        headers: {'Authorization': 'Bearer $apiKey'},
      );

      if (response.statusCode == 200) {
        return CredentialValid();
      }

      final body = jsonDecode(response.body);
      final message = body['error']?['message'] as String? ?? 'Invalid API Key';
      return CredentialInvalid(message);
    } catch (_) {
      return CredentialInvalid('Could not reach OpenRouter. Check your connection.');
    }
  }
}