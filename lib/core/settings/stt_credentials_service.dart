import 'package:injectable/injectable.dart';
import 'package:lingu/core/settings/stores.dart';

@singleton
class STTCredentialsService {
  final PersistedNullableStringSignal apiKey;

  STTCredentialsService._(SecureStore secureStore)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'sttApiKey',
        store: secureStore,
      );

  @FactoryMethod(preResolve: true)
  static Future<STTCredentialsService> create(SecureStore secureStore) async {
    final instance = STTCredentialsService._(secureStore);
    await instance.apiKey.init();
    return instance;
  }

  bool get isConfigured => apiKey.value != null;
}
