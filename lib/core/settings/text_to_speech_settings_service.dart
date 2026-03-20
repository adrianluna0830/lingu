import 'package:injectable/injectable.dart';
import 'package:lingu/core/settings/stores.dart';
import 'package:signals/signals.dart';

@singleton
class TextToSpeechSettingsService {
  final PersistedNullableStringSignal apiKey;
  final PersistedBoolSignal customVoiceEnabled;
  final PersistedDoubleSignal practiceModeSpeakingRate;
  final PersistedNullableStringSignal customVoiceName;

  TextToSpeechSettingsService._(SharedPreferencesStore store)
    : apiKey = PersistedNullableStringSignal(
        null,
        'ttsApiKey',
        store: store,
      )  
    ,customVoiceEnabled = PersistedBoolSignal(
        false,
        'customVoiceEnabled',
        store: store,
      ),
      customVoiceName = PersistedNullableStringSignal(
        null,
        'customVoiceName',
        store: store,
      ),
      practiceModeSpeakingRate = PersistedDoubleSignal(
        1.0,
        'practiceModeSpeakingRate',
        store: store,
      );

  @FactoryMethod(preResolve: true)
  static Future<TextToSpeechSettingsService> create(
    SharedPreferencesStore store,
  ) async {
    final instance = TextToSpeechSettingsService._(store);
    await Future.wait([
      instance.practiceModeSpeakingRate.init(),
      instance.customVoiceEnabled.init(),
      instance.customVoiceName.init(),
      instance.apiKey.init(),
    ]);
    return instance;
  }
}
