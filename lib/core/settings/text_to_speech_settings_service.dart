import 'package:lingu/core/settings/stores.dart';

class TextToSpeechSettingsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedBoolSignal customVoiceEnabled;
  final PersistedDoubleSignal practiceModeSpeakingRate;
  final PersistedNullableStringSignal customVoiceName;

  TextToSpeechSettingsService._(SharedPreferencesStore store)
    : apiKey = PersistedNullableStringSignal(
        null,
        key: 'ttsApiKey',
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
      instance.apiKey.init(),
    ]);
    return instance;
  }
}
