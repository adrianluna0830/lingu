import 'package:injectable/injectable.dart';
import 'package:lingu/core/settings/stores.dart';

@singleton
class AICredentialsService {
  final PersistedNullableStringSignal apiKey;

  AICredentialsService._(SecureStore secureStore)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'geminiApiKey',
        store: secureStore,
      );

  @FactoryMethod(preResolve: true)
  static Future<AICredentialsService> create(SecureStore secureStore) async {
    final instance = AICredentialsService._(secureStore);
    await instance.apiKey.init();
    return instance;
  }

  bool get isConfigured => apiKey.value != null;
}
