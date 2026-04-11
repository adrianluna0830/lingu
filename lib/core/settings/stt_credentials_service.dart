import 'package:lingu/core/settings/stores.dart';

class STTCredentialsService {
  final PersistedNullableStringSignal apiKey;

  STTCredentialsService._(SecureStore secureStore)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'sttApiKey',
        store: secureStore,
      );
static Future<STTCredentialsService> create(SecureStore secureStore) async {
    final instance = STTCredentialsService._(secureStore);
    await instance.apiKey.init();
    return instance;
  }

  bool get isConfigured => apiKey.value != null;
}
