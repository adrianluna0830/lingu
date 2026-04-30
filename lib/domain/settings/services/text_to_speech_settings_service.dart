import 'package:lingu/domain/settings/stores.dart';

class TextToSpeechSettingsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedNullableStringSignal replicateApiKey;
  final PersistedNullableStringSignal azureApiKey;
  final PersistedNullableStringSignal azureRegion;
  final PersistedBoolSignal customVoiceEnabled;
  final PersistedDoubleSignal practiceModeSpeakingRate;
  final PersistedNullableStringSignal customVoiceName;

  TextToSpeechSettingsService._(SharedPreferencesStore store)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'ttsApiKey',
        store: store,
      ),
      replicateApiKey = PersistedNullableStringSignal(
        null,
        key: 'ttsReplicateApiKey',
        store: store,
      ),
      azureApiKey = PersistedNullableStringSignal(
        null,
        key: 'ttsAzureApiKey',
        store: store,
      ),
      azureRegion = PersistedNullableStringSignal(
        null,
        key: 'ttsAzureRegion',
        store: store,
      ),
      customVoiceEnabled = PersistedBoolSignal(
        false,
        key: 'customVoiceEnabled',
        store: store,
      ),
      customVoiceName = PersistedNullableStringSignal(
        null,
        key: 'customVoiceName',
        store: store,
      ),
      practiceModeSpeakingRate = PersistedDoubleSignal(
        1.0,
        key: 'practiceModeSpeakingRate',
        store: store,
      );
static Future<TextToSpeechSettingsService> create(
    SharedPreferencesStore store,
  ) async {
    final instance = TextToSpeechSettingsService._(store);
    await Future.wait<void>([
      instance.practiceModeSpeakingRate.init(),
      instance.customVoiceEnabled.init(),
      instance.customVoiceName.init(),
      instance.replicateApiKey.init(),
      instance.azureApiKey.init(),
      instance.azureRegion.init(),
      instance.apiKey.init(),
    ]);
    return instance;
  }
}
