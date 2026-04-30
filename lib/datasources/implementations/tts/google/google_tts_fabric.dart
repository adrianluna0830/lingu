import 'dart:async';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/settings/services/text_to_speech_settings_service.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/datasources/implementations/tts/google/google_tts_service.dart';

class GoogleTTSFabric implements IAPIFabric<ITextToSpeechService> {
  final TextToSpeechSettingsService _settingsService;

  GoogleTTSFabric(this._settingsService);

  @override
  Future<CredentialValidationResult> validate() async {
    final apiKey = _settingsService.apiKey.value;

    if (apiKey == null || apiKey.isEmpty) {
      return CredentialInvalid('API key vacía');
    }

    final client = clientViaApiKey(apiKey);
    final ttsApi = TexttospeechApi(client);

    try {
      await ttsApi.voices.list().timeout(const Duration(seconds: 10));
      return CredentialValid();
    } on DetailedApiRequestError catch (e) {
      if (e.status == 401 || e.status == 403) {
        return CredentialInvalid('API key invalid or not authorized');
      }
      return CredentialInvalid(e.message ?? 'Unknown API error');
    } on TimeoutException {
      return CredentialNetworkError();
    } catch (_) {
      return CredentialNetworkError();
    } finally {
      client.close();
    }
  }

  @override
  Future<ITextToSpeechService> create() async {
    final apiKey = _settingsService.apiKey.value;
    assert(apiKey != null, 'TTS API key must be configured');
    assert(apiKey!.isNotEmpty, 'TTS API key cannot be empty');

    final client = clientViaApiKey(apiKey!);
    final ttsApi = TexttospeechApi(client);

    return GoogleTTSService(
      api: ttsApi,
      httpClient: client,
      apiKey: apiKey,
    );
  }
}