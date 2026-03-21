import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:lingu/core/settings/locale_settings_service.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';
import 'package:lingu/core/router/app_router.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final aiService = di<AICredentialsService>();
    final localeService = di<LocaleSettingsService>();
    final pronunciationService = di<PronunciationAssessmentCredentialsService>();
    final ttsService = di<TextToSpeechSettingsService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SettingTile(
            title: 'Native Language',
            value: localeService.nativeLocale.watch(context)?.name ?? 'Not set',
            onTap: () => context.router.push(NativeLocaleRoute(onComplete: () => context.router.maybePop())),
          ),
          _SettingTile(
            title: 'Learning Language',
            value: localeService.learningLocale.watch(context)?.name ?? 'Not set',
            onTap: () => context.router.push(LearningLocaleRoute(onComplete: () => context.router.maybePop())),
          ),
          _SecretSettingTile(
            title: 'AI API Key',
            value: aiService.apiKey.watch(context) ?? 'Not set',
            onTap: () => context.router.push(AICredentialsRoute(onComplete: () => context.router.maybePop())),
          ),
          _PronunciationSettingTile(
            apiKey: pronunciationService.apiKey.watch(context) ?? 'Not set',
            endpoint: pronunciationService.endpoint.watch(context) ?? 'Not set',
            onTap: () => context.router.push(PronunciationAssessmentCredentialsRoute(onComplete: () => context.router.maybePop())),
          ),
          _SecretSettingTile(
            title: 'TTS API Key',
            value: ttsService.apiKey.watch(context) ?? 'Not set',
            onTap: () => context.router.push(TTSCredentialsRoute(onComplete: () => context.router.maybePop())),
          ),
        ],
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SettingTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _PronunciationSettingTile extends StatefulWidget {
  final String apiKey;
  final String endpoint;
  final VoidCallback onTap;

  const _PronunciationSettingTile({
    required this.apiKey,
    required this.endpoint,
    required this.onTap,
  });

  @override
  State<_PronunciationSettingTile> createState() => _PronunciationSettingTileState();
}

class _PronunciationSettingTileState extends State<_PronunciationSettingTile> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final displayKey = _obscured && widget.apiKey != 'Not set'
        ? '•' * widget.apiKey.length
        : widget.apiKey;

    return ListTile(
      title: const Text('Pronunciation Assessment'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Key:'),
          Text(displayKey),
          const SizedBox(height: 4),
          const Text('Endpoint:'),
          Text(widget.endpoint),
        ],
      ),
      isThreeLine: true,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscured = !_obscured),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: widget.onTap,
    );
  }
}

class _SecretSettingTile extends StatefulWidget {
  final String title;
  final String value;
  final VoidCallback onTap;

  const _SecretSettingTile({
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  State<_SecretSettingTile> createState() => _SecretSettingTileState();
}

class _SecretSettingTileState extends State<_SecretSettingTile> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final displayValue = _obscured && widget.value != 'Not set'
        ? '•' * widget.value.length
        : widget.value;

    return ListTile(
      title: Text(widget.title),
      subtitle: Text(displayValue),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_obscured ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscured = !_obscured),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: widget.onTap,
    );
  }
}
