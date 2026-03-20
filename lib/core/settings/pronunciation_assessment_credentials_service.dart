import 'package:injectable/injectable.dart';
import 'package:lingu/core/settings/stores.dart';
import 'package:signals/signals.dart';

@singleton
class PronunciationAssessmentCredentialsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedNullableStringSignal endpoint;

  PronunciationAssessmentCredentialsService._(
    SecureStore secureStore,
    SharedPreferencesStore store,
  ) : apiKey = PersistedNullableStringSignal(
        null,
        'sttApiKey',
        store: secureStore,
      ),
      endpoint = PersistedNullableStringSignal(
        null,
        'sttEndpoint',
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
    await Future.wait([instance.apiKey.init(), instance.endpoint.init()]);
    return instance;
  }

  bool get isConfigured => apiKey.value != null && endpoint.value != null;
}
