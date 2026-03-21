import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/language_locale.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class LearningLocaleView extends StatefulWidget {
  final VoidCallback onComplete;

  const LearningLocaleView({super.key, required this.onComplete});

  @override
  State<LearningLocaleView> createState() => _LearningLocaleViewState();
}

class _LearningLocaleViewState extends State<LearningLocaleView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _selectedLocale = createSignal<LanguageLocale?>(null);

  @override
  void initState() {
    super.initState();
    _selectedLocale.value = di<LocaleSettingsService>().learningLocale.value;
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
            child: Watch((context) {
              return ListView(
                children: LanguageLocale.values.map((locale) {
                  return RadioListTile<LanguageLocale>(
                    title: Text(_getLocaleName(locale)),
                    value: locale,
                    groupValue: _selectedLocale.value,
                    onChanged: _isProcessing.value
                        ? null
                        : (val) => _selectedLocale.value = val,
                  );
                }).toList(),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Watch((context) {
              return ElevatedButton(
                onPressed: (_selectedLocale.value == null || _isProcessing.value)
                    ? null
                    : () {
                        _isProcessing.value = true;
                        di<LocaleSettingsService>().learningLocale.value = _selectedLocale.value;
                        widget.onComplete();
                      },
                child: const Text("Continue"),
              );
            }),
          ),
        ],
      ),
    );
  }
}
