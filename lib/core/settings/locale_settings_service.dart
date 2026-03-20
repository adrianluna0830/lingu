import 'package:injectable/injectable.dart';
import 'package:lingu/core/language_locale.dart';
import 'package:lingu/core/settings/stores.dart';

@singleton
class LocaleSettingsService {
  final PersistedNullableEnumSignal<LanguageLocale> nativeLocale;
  final PersistedNullableEnumSignal<LanguageLocale> learningLocale;

  LocaleSettingsService._(SharedPreferencesStore store)
    : nativeLocale = PersistedNullableEnumSignal(
        'appNativeLocale',
        LanguageLocale.values,
        store: store,
      ),
      learningLocale = PersistedNullableEnumSignal(
        'appLearningLocale',
        LanguageLocale.values,
        store: store,
      );

  @FactoryMethod(preResolve: true)
  static Future<LocaleSettingsService> create(
    SharedPreferencesStore store,
  ) async {
    final instance = LocaleSettingsService._(store);
    await Future.wait([
      instance.nativeLocale.init(),
      instance.learningLocale.init(),
    ]);
    return instance;
  }

  bool get isConfigured =>
      nativeLocale.value != null && learningLocale.value != null;
}



