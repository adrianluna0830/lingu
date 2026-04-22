import 'package:lingu/core/settings/stores.dart';

class ImageCredentialsService {
  final PersistedNullableStringSignal pixabayApiKey;

  ImageCredentialsService._(SecureStore secureStore)
      : pixabayApiKey = PersistedNullableStringSignal(
          null,
          key: 'pixabayApiKey',
          store: secureStore,
        );

  static Future<ImageCredentialsService> create(SecureStore secureStore) async {
    final instance = ImageCredentialsService._(secureStore);
    await instance.pixabayApiKey.init();
    return instance;
  }

  bool get isConfigured => pixabayApiKey.value != null;
}
