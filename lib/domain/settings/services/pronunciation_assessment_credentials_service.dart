import 'package:lingu/domain/settings/stores.dart';

class PronunciationAssessmentCredentialsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedNullableStringSignal endpoint;

  PronunciationAssessmentCredentialsService._(
    SecureStore secureStore,
    SharedPreferencesStore store,
  ) : apiKey = PersistedNullableStringSignal(
        null,
        key: 'pronunciationApiKey',
        store: secureStore,
      ),
      endpoint = PersistedNullableStringSignal(
        null,
        key: 'pronunciationEndpoint',
        store: store,
      );
static Future<PronunciationAssessmentCredentialsService> create(
    SecureStore secureStore,
    SharedPreferencesStore store,
  ) async {
    final instance = PronunciationAssessmentCredentialsService._(
      secureStore,
      store,
    );
    await Future.wait<void>([instance.apiKey.init(), instance.endpoint.init()]);
    return instance;
  }

  bool get isConfigured => apiKey.value != null && endpoint.value != null;
}
