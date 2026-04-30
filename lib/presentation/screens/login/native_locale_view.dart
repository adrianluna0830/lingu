import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/domain/settings/services/locale_settings_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class NativeLocaleView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isSetupFlow;

  const NativeLocaleView({
    super.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  @override
  State<NativeLocaleView> createState() => _NativeLocaleViewState();
}

class _NativeLocaleViewState extends State<NativeLocaleView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _selectedLocale = createSignal<LanguageLocale?>(null);

  @override
  void initState() {
    super.initState();
    _selectedLocale.value = di<LocaleSettingsService>().nativeLocale.value;
  }

  String _getLocaleName(LanguageLocale locale) {
    return switch (locale) {
      LanguageLocale.en => 'English',
      LanguageLocale.es => 'Spanish',
      LanguageLocale.de => 'German',
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isSetupFlow,
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Native Locale'),
        automaticallyImplyLeading: !widget.isSetupFlow,
      ),
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
                        di<LocaleSettingsService>().nativeLocale.value = _selectedLocale.value;
                        widget.onComplete();
                      },
                child: const Text("Continue"),
              );
            }),
          ),
        ],
      ),
    ));
  }
}
