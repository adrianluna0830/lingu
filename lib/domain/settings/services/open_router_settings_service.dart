import 'package:lingu/domain/settings/stores.dart';

class OpenRouterSettingsService {
  final PersistedNullableStringSignal apiKey;

  OpenRouterSettingsService._(SecureStore secureStore)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'openRouterApiKey',
        store: secureStore,
      );

  static Future<OpenRouterSettingsService> create(SecureStore secureStore) async {
    final instance = OpenRouterSettingsService._(secureStore);
    await instance.apiKey.init();
    return instance;
  }

  bool get isConfigured => apiKey.value != null && apiKey.value!.isNotEmpty;
}
