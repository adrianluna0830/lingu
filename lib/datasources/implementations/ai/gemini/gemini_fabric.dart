import 'package:googleai_dart/googleai_dart.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/datasources/implementations/ai/gemini/gemini_service.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/settings/services/ai_credentials_service.dart';

class GeminiFabric implements IAPIFabric<IAIService> {
  final AICredentialsService _credentialsService;
  GeminiFabric(this._credentialsService);

  @override
  Future<IAIService> create() async {
    final apiKey = _credentialsService.apiKey.value;
    assert(apiKey != null, 'API key must be configured');
    assert(apiKey!.isNotEmpty, 'API key cannot be empty');


    final policy = RetryPolicy(
      maxRetries: 4,
      initialDelay: Duration(seconds: 1),
      maxDelay: Duration(seconds: 30),
      jitter: 0.2,
    );

    final googleClient = GoogleAIClient(
      config: GoogleAIConfig.googleAI(
        apiVersion: ApiVersion.v1beta,
        authProvider: ApiKeyProvider(apiKey!),
        retryPolicy: policy,
      ),
    );

    return GeminiService(
      client: googleClient,
modelType: GeminiModelType.gemini25FlashLite,
    );
  }

  @override
  Future<CredentialValidationResult> validate() async {
    final apiKey = _credentialsService.apiKey.value;

    if (apiKey == null || apiKey.isEmpty) {
      return CredentialInvalid('API key vacía');
    }

    final googleClient = GoogleAIClient(
      config: GoogleAIConfig.googleAI(
        apiVersion: ApiVersion.v1beta,
        authProvider: ApiKeyProvider(apiKey),
      ),
    );

    try {
      await googleClient.models.list();
      return CredentialValid();
    } on AuthenticationException {
      return CredentialInvalid('API key invalid');
    } on ApiException catch (e) {
      if (e.statusCode == 403) {
        return CredentialInvalid('API key does not have access to the Gemini API');
      }
      return CredentialInvalid(e.message);
    } on TimeoutException {
      return CredentialNetworkError();
    } catch (_) {
      return CredentialNetworkError();
    } finally {
      googleClient.close();
    }
  }
}
