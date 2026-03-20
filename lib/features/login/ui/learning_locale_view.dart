import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/language_locale.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';

@RoutePage()
class LearningLocaleView extends StatefulWidget {
  final VoidCallback onComplete;

  const LearningLocaleView({required this.onComplete});

  @override
  State<LearningLocaleView> createState() => _LearningLocaleViewState();
}

class _LearningLocaleViewState extends State<LearningLocaleView> {
  bool _isProcessing = false;
  LanguageLocale? _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = di<LocaleSettingsService>().learningLocale.value;
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
      appBar: AppBar(title: const Text('Learning Locale')),
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
                      di<LocaleSettingsService>().learningLocale.value = _selectedLocale;
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
