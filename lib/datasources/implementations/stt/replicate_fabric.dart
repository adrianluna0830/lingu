import 'package:lingu/datasources/implementations/stt/replicate_stt_service.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/settings/services/replicate_settings_service.dart';

class ReplicateFabric implements IAPIFabric<ISpeechToTextService> {
  final ReplicateSettingsService _settings;

  ReplicateFabric(this._settings);

  @override
  Future<ISpeechToTextService> create() async {
    final apiToken = _settings.apiToken.value;
    if (apiToken == null || apiToken.isEmpty) {
      throw Exception('Replicate API Token not configured');
    }
    return ReplicateSttService(apiToken: apiToken);
  }

  @override
  Future<CredentialValidationResult> validate() async {
    if (!_settings.isConfigured) {
      return CredentialInvalid('Replicate API Token is required');
    }
    return CredentialValid();
  }
}
