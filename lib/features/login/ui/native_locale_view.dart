import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/language_locale.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';

@RoutePage()
class NativeLocaleView extends StatefulWidget {
  final VoidCallback onComplete;

  const NativeLocaleView({required this.onComplete});

  @override
  State<NativeLocaleView> createState() => _NativeLocaleViewState();
}

class _NativeLocaleViewState extends State<NativeLocaleView> {
  bool _isProcessing = false;
  LanguageLocale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = di<LocaleSettingsService>().nativeLocale.value;
  }

  String _getLocaleName(LanguageLocale locale) {
    return switch (locale) {
      LanguageLocale.en => 'English',
      LanguageLocale.es => 'Spanish',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Locale')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: LanguageLocale.values.map((locale) {
                return RadioListTile<LanguageLocale>(
                  title: Text(_getLocaleName(locale)),
                  value: locale,
                  groupValue: _selectedLocale,
                  onChanged: _isProcessing
                      ? null
                      : (val) => setState(() => _selectedLocale = val),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (_selectedLocale == null || _isProcessing)
                  ? null
                  : () {
                      setState(() => _isProcessing = true);
                      di<LocaleSettingsService>().nativeLocale.value = _selectedLocale;
                      widget.onComplete();
                    },
              child: const Text("Continue"),
            ),
          ),
        ],
      ),
    );
  }
}
