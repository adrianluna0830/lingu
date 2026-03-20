enum LanguageLocale {
  en('en-US'),
  es('es-MX');

  final String bcp47;
  const LanguageLocale(this.bcp47);
}