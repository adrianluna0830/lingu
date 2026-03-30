import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/models/cefr.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class CEFRLevelView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isSetupFlow;

  const CEFRLevelView({
    super.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  @override
  State<CEFRLevelView> createState() => _CEFRLevelViewState();
}

class _CEFRLevelViewState extends State<CEFRLevelView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _selectedLevel = createSignal<CEFR?>(null);

  @override
  void initState() {
    super.initState();
    _selectedLevel.value = di<LocaleSettingsService>().currentTargetLanguageCEFR.value;
  }

  String _getLevelDescription(CEFR level) {
    return switch (level) {
      CEFR.a1 => 'Beginner. Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
      CEFR.a2 => 'Elementary. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      CEFR.b1 => 'Intermediate. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.',
      CEFR.b2 => 'Upper Intermediate. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum.',
      CEFR.c1 => 'Advanced. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia.',
      CEFR.c2 => 'Proficient. Deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet.',
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isSetupFlow,
      child: Scaffold(
        appBar: AppBar(
        title: const Text('CEFR Level'),
        automaticallyImplyLeading: !widget.isSetupFlow,
      ),
      body: Column(
        children: [
          Expanded(
            child: Watch((context) {
              return ListView(
                children: CEFR.values.map((level) {
                  return RadioListTile<CEFR>(
                    title: Text(level.name.toUpperCase()),
                    subtitle: Text(_getLevelDescription(level)),
                    value: level,
                    groupValue: _selectedLevel.value,
                    onChanged: _isProcessing.value
                        ? null
                        : (val) => _selectedLevel.value = val,
                  );
                }).toList(),
              );
            }),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Watch((context) {
              return ElevatedButton(
                onPressed: (_selectedLevel.value == null || _isProcessing.value)
                    ? null
                    : () {
                        _isProcessing.value = true;
                        di<LocaleSettingsService>().currentTargetLanguageCEFR.value = _selectedLevel.value;
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
