import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/ai/core/i_ai_model.dart';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/models/credential_results.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/ai_credentials_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class AICredentialsView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isSetupFlow;

  const AICredentialsView({
    super.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  @override
  State<AICredentialsView> createState() => _AICredentialsViewState();
}

class _AICredentialsViewState extends State<AICredentialsView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _obscureApiKey = createSignal(true);
  late final _errorText = createSignal<String?>(null);
  late final TextEditingController _apiKeyController;
  late final _apiKeyText = createSignal('');

  @override
  void initState() {
    super.initState();
    final existingKey = di<AICredentialsService>().apiKey.value;
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

    di<AICredentialsService>().apiKey.value = _apiKeyController.text;
    final fabric = di<IAPIFabric<IAIService>>();
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
        title: const Text('Gemini Credentials'),
        automaticallyImplyLeading: !widget.isSetupFlow,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Watch((context) {
            return TextField(
              controller: _apiKeyController,
              obscureText: _obscureApiKey.value,
              decoration: InputDecoration(
                labelText: 'Gemini API Key',
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
      ),
    );
  }
}
