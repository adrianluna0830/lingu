import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/settings/services/text_to_speech_settings_service.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/datasources/implementations/tts/qwen_azure/qwen_azure_tts_service.dart';

class QwenAzureTTSFabric implements IAPIFabric<ITextToSpeechService> {
  final TextToSpeechSettingsService _settingsService;

  QwenAzureTTSFabric(this._settingsService);

  @override
  Future<CredentialValidationResult> validate() async {
    final replicateKey = _settingsService.replicateApiKey.value;
    final azureKey = _settingsService.azureApiKey.value;
    final azureRegion = _settingsService.azureRegion.value;

    if (replicateKey == null || replicateKey.isEmpty) {
      return CredentialInvalid('Replicate API key is empty');
    }
    if (azureKey == null || azureKey.isEmpty) {
      return CredentialInvalid('Azure API key is empty');
    }
    if (azureRegion == null || azureRegion.isEmpty) {
      return CredentialInvalid('Azure Region is empty');
    }

    // A basic check to ensure the length seems ok, could add an actual API call here to validate
    if (replicateKey.length < 10) {
      return CredentialInvalid('Replicate API key seems invalid');
    }

    return CredentialValid();
  }

  @override
  Future<ITextToSpeechService> create() async {
    final replicateKey = _settingsService.replicateApiKey.value;
    final azureKey = _settingsService.azureApiKey.value;
    final azureRegion = _settingsService.azureRegion.value;

    assert(replicateKey != null && replicateKey.isNotEmpty, 'Replicate API key must be configured');
    assert(azureKey != null && azureKey.isNotEmpty, 'Azure API key must be configured');
    assert(azureRegion != null && azureRegion.isNotEmpty, 'Azure Region must be configured');

    final client = http.Client();

    return QwenAzureTTSService(
      httpClient: client,
      replicateApiKey: replicateKey!,
      azureApiKey: azureKey!,
      azureRegion: azureRegion!,
    );
  }
}
