enum LanguageLocale {
  en('en-US'),
  es('es-MX'),
  de('de-DE');

  final String bcp47;
  const LanguageLocale(this.bcp47);

  String get display => name.toUpperCase();
}

class NativeLocale {
  final LanguageLocale value;
  const NativeLocale(this.value);
}

class TargetLocale {
  final LanguageLocale value;
  const TargetLocale(this.value);
}