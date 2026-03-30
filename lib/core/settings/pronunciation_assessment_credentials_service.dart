import 'package:injectable/injectable.dart';
import 'package:lingu/core/settings/stores.dart';

@singleton
class PronunciationAssessmentCredentialsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedNullableStringSignal endpoint;

  PronunciationAssessmentCredentialsService._(
    SecureStore secureStore,
    SharedPreferencesStore store,
  ) : apiKey = PersistedNullableStringSignal(
        null,
        key: 'sttApiKey',
        store: secureStore,
      ),
      endpoint = PersistedNullableStringSignal(
        null,
        key: 'sttEndpoint',
        store: store,
      );

  @FactoryMethod(preResolve: true)
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
