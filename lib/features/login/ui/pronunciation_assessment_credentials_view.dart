import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/interfaces/i_fabric.dart';
import 'package:lingu/core/models/credential_results.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';
import 'package:signals/signals_flutter.dart';

@RoutePage()
class PronunciationAssessmentCredentialsView extends StatefulWidget {
  final VoidCallback onComplete;
  final bool isSetupFlow;

  const PronunciationAssessmentCredentialsView({
    super.key,
    required this.onComplete,
    this.isSetupFlow = false,
  });

  @override
  State<PronunciationAssessmentCredentialsView> createState() =>
      _PronunciationAssessmentCredentialsViewState();
}

class _PronunciationAssessmentCredentialsViewState
    extends State<PronunciationAssessmentCredentialsView> with SignalsMixin {
  late final _isProcessing = createSignal(false);
  late final _obscureApiKey = createSignal(true);
  late final TextEditingController _apiKeyController;
  late final TextEditingController _endpointController;
  late final _apiKeyText = createSignal('');
  late final _endpointText = createSignal('');
  late final _errorText = createSignal<String?>(null);

  @override
  void initState() {
    super.initState();
    final service = di<PronunciationAssessmentCredentialsService>();
    _apiKeyController = TextEditingController(text: service.apiKey.value);
    _endpointController = TextEditingController(text: service.endpoint.value);
    _apiKeyText.value = service.apiKey.value ?? '';
    _endpointText.value = service.endpoint.value ?? '';

    _apiKeyController.addListener(_onApiKeyChanged);
    _endpointController.addListener(_onEndpointChanged);
  }

  void _onApiKeyChanged() => _apiKeyText.value = _apiKeyController.text;
  void _onEndpointChanged() => _endpointText.value = _endpointController.text;

  Future<void> _validateAndContinue() async {
    _isProcessing.value = true;
    _errorText.value = null;

    final service = di<PronunciationAssessmentCredentialsService>();
    service.apiKey.value = _apiKeyController.text;
    service.endpoint.value = _endpointController.text;

    final fabric = di<IAPIFabric<IPronunciationAssessmentService>>();
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
  void dispose() {
    _apiKeyController.removeListener(_onApiKeyChanged);
    _endpointController.removeListener(_onEndpointChanged);
    _apiKeyController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !widget.isSetupFlow,
      child: Scaffold(
        appBar: AppBar(
        title: const Text('Pronunciation Assessment'),
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
                labelText: 'API Key',
                errorText: _errorText.value,
                suffixIcon: IconButton(
                  icon: Icon(_obscureApiKey.value ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => _obscureApiKey.value = !_obscureApiKey.value,
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          TextField(
            controller: _endpointController,
            decoration: const InputDecoration(labelText: 'Endpoint'),
          ),
          const SizedBox(height: 24),
          Watch((context) {
            final canContinue = _apiKeyText.value.isNotEmpty &&
                _endpointText.value.isNotEmpty &&
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
