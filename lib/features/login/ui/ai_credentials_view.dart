import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';

@RoutePage()
class AICredentialsView extends StatefulWidget {
  final VoidCallback onComplete;

  const AICredentialsView({required this.onComplete});

  @override
  State<AICredentialsView> createState() => _AICredentialsViewState();
}

class _AICredentialsViewState extends State<AICredentialsView> {
  bool _isProcessing = false;
  bool _obscureApiKey = true;
  late final TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    final existingKey = di<AICredentialsService>().apiKey.value;
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
      appBar: AppBar(title: const Text('Gemini Credentials')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            decoration: InputDecoration(
              labelText: 'Gemini API Key',
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
                        di<AICredentialsService>().apiKey.value = _apiKeyController.text;
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
