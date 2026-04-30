import 'package:lingu/domain/settings/stores.dart';

class MicrosoftSettingsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedNullableStringSignal region;

  MicrosoftSettingsService._(SecureStore secureStore, SharedPreferencesStore sharedStore)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'microsoftApiKey',
        store: secureStore,
      ),
      region = PersistedNullableStringSignal(
        null,
        key: 'microsoftRegion',
        store: sharedStore,
      );

  static Future<MicrosoftSettingsService> create(
    SecureStore secureStore,
    SharedPreferencesStore sharedStore,
  ) async {
    final instance = MicrosoftSettingsService._(secureStore, sharedStore);
    await Future.wait([
      instance.apiKey.init(),
      instance.region.init(),
    ]);
    return instance;
  }

  bool get isConfigured =>
      apiKey.value != null &&
      apiKey.value!.isNotEmpty &&
      region.value != null &&
      region.value!.isNotEmpty;
}
