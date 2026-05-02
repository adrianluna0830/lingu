import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/interfaces/stt/i_speech_to_text_service.dart';
import 'package:lingu/domain/core/i_fabric.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/settings/services/open_router_settings_service.dart';
import 'package:lingu/domain/settings/services/microsoft_settings_service.dart';
import 'package:lingu/domain/settings/services/replicate_settings_service.dart';
import 'package:lingu/datasources/implementations/pronunciation_assessment/microsoft_fabric.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class LoginView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isSetupFlow;

  const LoginView({
    super.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _openRouterError = createSignal<String?>(null);
  late final _microsoftError = createSignal<String?>(null);
  late final _replicateError = createSignal<String?>(null);

  late final TextEditingController _openRouterKeyController;
  late final TextEditingController _microsoftKeyController;
  late final TextEditingController _microsoftRegionController;
  late final TextEditingController _replicateTokenController;

  @override
  void initState() {
    super.initState();
    _openRouterKeyController = TextEditingController(text: di<OpenRouterSettingsService>().apiKey.value);
    _microsoftKeyController = TextEditingController(text: di<MicrosoftSettingsService>().apiKey.value);
    _microsoftRegionController = TextEditingController(text: di<MicrosoftSettingsService>().region.value);
    _replicateTokenController = TextEditingController(text: di<ReplicateSettingsService>().apiToken.value);
  }

  @override
  void dispose() {
    _openRouterKeyController.dispose();
    _microsoftKeyController.dispose();
    _microsoftRegionController.dispose();
    _replicateTokenController.dispose();
    super.dispose();
  }

  Future<void> _validateAndContinue() async {
    _isProcessing.value = true;
    _openRouterError.value = null;
    _microsoftError.value = null;
    _replicateError.value = null;

    // Save values
    di<OpenRouterSettingsService>().apiKey.value = _openRouterKeyController.text;
    di<MicrosoftSettingsService>().apiKey.value = _microsoftKeyController.text;
    di<MicrosoftSettingsService>().region.value = _microsoftRegionController.text;
    di<ReplicateSettingsService>().apiToken.value = _replicateTokenController.text;

    try {
      // Validate all 3 services
      final openRouterFabric = di<IAPIFabric<IAIService>>();
      final replicateFabric = di<IAPIFabric<ISpeechToTextService>>();
      final microsoftFabric = di<MicrosoftFabric>();

      final results = await Future.wait([
        openRouterFabric.validate(),
        replicateFabric.validate(),
        microsoftFabric.validate(),
      ]);

      if (!mounted) return;

      final orRes = results[0];
      final repRes = results[1];
      final msRes = results[2];

      bool hasError = false;

      if (orRes is! CredentialValid) {
        _openRouterError.value = orRes is CredentialInvalid ? orRes.reason : 'Network error';
        hasError = true;
      }
      if (repRes is! CredentialValid) {
        _replicateError.value = repRes is CredentialInvalid ? repRes.reason : 'Network error';
        hasError = true;
      }
      if (msRes is! CredentialValid) {
        _microsoftError.value = msRes is CredentialInvalid ? msRes.reason : 'Network error';
        hasError = true;
      }

      if (!hasError) {
        widget.onComplete();
      } else {
        _isProcessing.value = false;
      }
    } catch (e) {
      _isProcessing.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during validation: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lingu Setup'),
        automaticallyImplyLeading: !widget.isSetupFlow,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Configure your API services to get started.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('OpenRouter (AI)'),
          Watch((context) => TextField(
            controller: _openRouterKeyController,
            decoration: InputDecoration(
              labelText: 'OpenRouter API Key',
              hintText: 'sk-or-v1-...',
              errorText: _openRouterError.value,
            ),
            obscureText: true,
          )),
          const SizedBox(height: 24),

          _buildSectionTitle('Microsoft Azure (TTS & Pronunciation)'),
          Watch((context) => TextField(
            controller: _microsoftKeyController,
            decoration: InputDecoration(
              labelText: 'Azure API Key',
              errorText: _microsoftError.value,
            ),
            obscureText: true,
          )),
          const SizedBox(height: 12),
          TextField(
            controller: _microsoftRegionController,
            decoration: const InputDecoration(
              labelText: 'Azure Region',
              hintText: 'eastus, westus, etc.',
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Replicate (STT)'),
          Watch((context) => TextField(
            controller: _replicateTokenController,
            decoration: InputDecoration(
              labelText: 'Replicate API Token',
              hintText: 'r8_...',
              errorText: _replicateError.value,
            ),
            obscureText: true,
          )),
          
          const SizedBox(height: 32),
          
          Watch((context) {
            return Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isProcessing.value ? null : _validateAndContinue,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isProcessing.value
                        ? const CircularProgressIndicator()
                        : const Text('Finish Setup'),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey),
      ),
    );
  }
}
