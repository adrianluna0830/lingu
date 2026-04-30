import 'package:lingu/domain/settings/stores.dart';

class AICredentialsService {
  final PersistedNullableStringSignal apiKey;

  AICredentialsService._(SecureStore secureStore)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'geminiApiKey',
        store: secureStore,
      );
static Future<AICredentialsService> create(SecureStore secureStore) async {
    final instance = AICredentialsService._(secureStore);
    await instance.apiKey.init();
    return instance;
  }

  bool get isConfigured => apiKey.value != null;
}
