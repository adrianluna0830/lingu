import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/interfaces/tts/i_text_to_speech_service.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/settings/services/text_to_speech_settings_service.dart';
import 'package:signals/signals_flutter.dart';

class TTSCredentialsView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isSetupFlow;

  const TTSCredentialsView({
    super.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  @override
  State<TTSCredentialsView> createState() => _TTSCredentialsViewState();
}

class _TTSCredentialsViewState extends State<TTSCredentialsView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _obscureKeys = createSignal(true);
  late final _errorText = createSignal<String?>(null);

  late final TextEditingController _replicateApiKeyController;
  late final TextEditingController _azureApiKeyController;
  late final TextEditingController _azureRegionController;

  late final _replicateApiKeyText = createSignal('');
  late final _azureApiKeyText = createSignal('');
  late final _azureRegionText = createSignal('');

  @override
  void initState() {
    super.initState();
    final settings = di<TextToSpeechSettingsService>();
    
    final replicateKey = settings.replicateApiKey.value ?? '';
    final azureKey = settings.azureApiKey.value ?? '';
    final azureRegion = settings.azureRegion.value ?? '';

    _replicateApiKeyController = TextEditingController(text: replicateKey);
    _azureApiKeyController = TextEditingController(text: azureKey);
    _azureRegionController = TextEditingController(text: azureRegion);

    _replicateApiKeyText.value = replicateKey;
    _azureApiKeyText.value = azureKey;
    _azureRegionText.value = azureRegion;

    _replicateApiKeyController.addListener(() => _replicateApiKeyText.value = _replicateApiKeyController.text);
    _azureApiKeyController.addListener(() => _azureApiKeyText.value = _azureApiKeyController.text);
    _azureRegionController.addListener(() => _azureRegionText.value = _azureRegionController.text);
  }

  @override
  void dispose() {
    _replicateApiKeyController.dispose();
    _azureApiKeyController.dispose();
    _azureRegionController.dispose();
    super.dispose();
  }

  Future<void> _validateAndContinue() async {
    _isProcessing.value = true;
    _errorText.value = null;

    final settings = di<TextToSpeechSettingsService>();
    settings.replicateApiKey.value = _replicateApiKeyController.text;
    settings.azureApiKey.value = _azureApiKeyController.text;
    settings.azureRegion.value = _azureRegionController.text;

    final fabric = di<IAPIFabric<ITextToSpeechService>>();
    final result = await fabric.validate();

    if (!mounted) return;

    if (result is CredentialValid) {
      widget.onComplete();
    } else {
      _isProcessing.value = false;
      if (result is CredentialInvalid) {
        _errorText.value = result.reason;
      } else {
        _errorText.value = 'Network Error. Please check your connection.';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isSetupFlow,
      child: Scaffold(
        appBar: AppBar(
        title: const Text('TTS Credentials'),
        automaticallyImplyLeading: !widget.isSetupFlow,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Watch((context) {
            return TextField(
              controller: _replicateApiKeyController,
              obscureText: _obscureKeys.value,
              decoration: InputDecoration(
                labelText: 'Replicate API Key (Qwen TTS)',
                errorText: _errorText.value,
                suffixIcon: IconButton(
                  icon: Icon(_obscureKeys.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => _obscureKeys.value = !_obscureKeys.value,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Watch((context) {
            return TextField(
              controller: _azureApiKeyController,
              obscureText: _obscureKeys.value,
              decoration: InputDecoration(
                labelText: 'Azure TTS API Key',
                errorText: _errorText.value,
              ),
            );
          }),
          const SizedBox(height: 16),
          Watch((context) {
            return TextField(
              controller: _azureRegionController,
              decoration: InputDecoration(
                labelText: 'Azure Region (e.g. eastus)',
                errorText: _errorText.value,
              ),
            );
          }),
          const SizedBox(height: 24),
          Watch((context) {
            final canContinue = _replicateApiKeyText.value.isNotEmpty && 
                                _azureApiKeyText.value.isNotEmpty && 
                                _azureRegionText.value.isNotEmpty && 
                                !_isProcessing.value;
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
    ));
  }
}
