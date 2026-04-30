import 'package:lingu/domain/settings/stores.dart';

class ReplicateSettingsService {
  final PersistedNullableStringSignal apiToken;

  ReplicateSettingsService._(SecureStore secureStore)
    : apiToken = PersistedNullableStringSignal(
        null,
        key: 'replicateApiToken',
        store: secureStore,
      );

  static Future<ReplicateSettingsService> create(SecureStore secureStore) async {
    final instance = ReplicateSettingsService._(secureStore);
    await instance.apiToken.init();
    return instance;
  }

  bool get isConfigured => apiToken.value != null && apiToken.value!.isNotEmpty;
}
