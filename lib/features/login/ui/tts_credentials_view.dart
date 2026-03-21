import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/credential_results.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';
import 'package:lingu/core/tts/core/i_tts_fabric.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class TTSCredentialsView extends StatefulWidget {
  final VoidCallback onComplete;

  const TTSCredentialsView({super.key, required this.onComplete});

  @override
  State<TTSCredentialsView> createState() => _TTSCredentialsViewState();
}

class _TTSCredentialsViewState extends State<TTSCredentialsView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _obscureApiKey = createSignal(true);
  late final _errorText = createSignal<String?>(null);
  late final TextEditingController _apiKeyController;
  late final _apiKeyText = createSignal('');

  @override
  void initState() {
    super.initState();
    final existingKey = di<TextToSpeechSettingsService>().apiKey.value;
    _apiKeyController = TextEditingController(text: existingKey);
    _apiKeyText.value = existingKey ?? '';
    _apiKeyController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    _apiKeyText.value = _apiKeyController.text;
  }

  @override
  void dispose() {
    _apiKeyController.removeListener(_onTextChanged);
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _validateAndContinue() async {
    _isProcessing.value = true;
    _errorText.value = null;

    di<TextToSpeechSettingsService>().apiKey.value = _apiKeyController.text;
    final fabric = di<ITTSFabric>();
    final result = await fabric.validate();

    if (!mounted) return;

    if (result is CredentialValid) {
      widget.onComplete();
    } else {
      _isProcessing.value = false;
      _errorText.value = 'Invalid API Key or Network Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STT Credentials')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Watch((context) {
            return TextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey.value,
              decoration: InputDecoration(
                labelText: 'STT API Key',
                errorText: _errorText.value,
                suffixIcon: IconButton(
                  icon: Icon(_obscureApiKey.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => _obscureApiKey.value = !_obscureApiKey.value,
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          Watch((context) {
            final canContinue = _apiKeyText.value.isNotEmpty && !_isProcessing.value;
            return ElevatedButton(
              onPressed: canContinue ? _validateAndContinue : null,
              child: _isProcessing.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Continue"),
            );
          }),
        ],
      ),
    );
  }
}
