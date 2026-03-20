import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/text_to_speech_settings_service.dart';

@RoutePage()
class TTSCredentialsView extends StatefulWidget {
  final VoidCallback onComplete;

  const TTSCredentialsView({required this.onComplete});

  @override
  State<TTSCredentialsView> createState() => _TTSCredentialsViewState();
}

class _TTSCredentialsViewState extends State<TTSCredentialsView> {
  bool _isProcessing = false;
  bool _obscureApiKey = true;
  late final TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    final existingKey = di<TextToSpeechSettingsService>().apiKey.value;
    _apiKeyController = TextEditingController(text: existingKey);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STT Credentials')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            decoration: InputDecoration(
              labelText: 'STT API Key',
              suffixIcon: IconButton(
                icon: Icon(_obscureApiKey ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: _apiKeyController,
            builder: (context, child) {
              final bool canContinue = _apiKeyController.text.isNotEmpty && !_isProcessing;
              return ElevatedButton(
                onPressed: canContinue
                    ? () {
                        setState(() => _isProcessing = true);
                        di<TextToSpeechSettingsService>().apiKey.value = _apiKeyController.text;
                        widget.onComplete();
                      }
                    : null,
                child: const Text("Continue"),
              );
            },
          ),
        ],
      ),
    );
  }
}
