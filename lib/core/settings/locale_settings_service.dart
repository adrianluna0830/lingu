import 'package:injectable/injectable.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/core/settings/stores.dart';

@singleton
class LocaleSettingsService {
  final PersistedNullableEnumSignal<LanguageLocale> nativeLocale;
  final PersistedNullableEnumSignal<LanguageLocale> learningLocale;
  late final TargetLanguageCEFRSignal<CEFR> currentTargetLanguageCEFR;

  LocaleSettingsService._(SharedPreferencesStore store)
    : nativeLocale = PersistedNullableEnumSignal(
        key: 'appNativeLocale',
        values: LanguageLocale.values,
        store: store,
      ),
      learningLocale = PersistedNullableEnumSignal(
        key: 'appLearningLocale',
        values: LanguageLocale.values,
        store: store,
      ) {
    currentTargetLanguageCEFR = TargetLanguageCEFRSignal<CEFR>(
      learningLocale,
      store: store,
      cefrValues: CEFR.values,
    );
  }

  @FactoryMethod(preResolve: true)
  static Future<LocaleSettingsService> create(
    SharedPreferencesStore store,
  ) async {
    final instance = LocaleSettingsService._(store);
    await Future.wait<void>([
      instance.nativeLocale.init(),
      instance.learningLocale.init(),
    ]);
    await instance.currentTargetLanguageCEFR.init();
    return instance;
  }

  bool get isConfigured =>
      nativeLocale.value != null && learningLocale.value != null && currentTargetLanguageCEFR.value != null;
}



