import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/settings/services/locale_settings_service.dart';
import 'package:lingu/domain/settings/services/image_credentials_service.dart';
import 'package:lingu/domain/settings/services/open_router_settings_service.dart';
import 'package:lingu/domain/settings/services/microsoft_settings_service.dart';
import 'package:lingu/domain/settings/services/replicate_settings_service.dart';
import 'package:lingu/domain/core/router/app_router.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final openRouter = di<OpenRouterSettingsService>();
    final microsoft = di<MicrosoftSettingsService>();
    final replicate = di<ReplicateSettingsService>();
    final localeService = di<LocaleSettingsService>();
    final imageService = di<ImageCredentialsService>();

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
          _SettingTile(
            title: 'CEFR Level',
            value: localeService.currentTargetLanguageCEFR.watch(context)?.name.toUpperCase() ?? 'Not set',
            onTap: () => context.router.push(CEFRLevelRoute(onComplete: () => context.router.maybePop())),
          ),
          const Divider(),
          _SecretSettingTile(
            title: 'OpenRouter (AI)',
            value: openRouter.apiKey.watch(context) ?? 'Not set',
            onTap: () => context.router.push(LoginRoute(onComplete: () => context.router.maybePop())),
          ),
          _MicrosoftSettingTile(
            apiKey: microsoft.apiKey.watch(context) ?? 'Not set',
            region: microsoft.region.watch(context) ?? 'Not set',
            onTap: () => context.router.push(LoginRoute(onComplete: () => context.router.maybePop())),
          ),
          _SecretSettingTile(
            title: 'Replicate (STT)',
            value: replicate.apiToken.watch(context) ?? 'Not set',
            onTap: () => context.router.push(LoginRoute(onComplete: () => context.router.maybePop())),
          ),
          const Divider(),
          _SecretSettingTile(
            title: 'Pixabay API Key',
            value: imageService.pixabayApiKey.watch(context) ?? 'Not set',
            onTap: () => context.router.push(LoginRoute(onComplete: () => context.router.maybePop())),
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

class _MicrosoftSettingTile extends StatefulWidget {
  final String apiKey;
  final String region;
  final VoidCallback onTap;

  const _MicrosoftSettingTile({
    required this.apiKey,
    required this.region,
    required this.onTap,
  });

  @override
  State<_MicrosoftSettingTile> createState() => _MicrosoftSettingTileState();
}

class _MicrosoftSettingTileState extends State<_MicrosoftSettingTile> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final displayKey = _obscured && widget.apiKey != 'Not set'
        ? '•' * widget.apiKey.length
        : widget.apiKey;

    return ListTile(
      title: const Text('Microsoft Azure (TTS & Pronunciation)'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key: $displayKey'),
          Text('Region: ${widget.region}'),
        ],
      ),
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
