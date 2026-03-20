import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/settings/pronunciation_assessment_credentials_service.dart';

@RoutePage()
class PronunciationAssessmentCredentialsView extends StatefulWidget {
  final VoidCallback onComplete;

  const PronunciationAssessmentCredentialsView({required this.onComplete});

  @override
  State<PronunciationAssessmentCredentialsView> createState() =>
      _PronunciationAssessmentCredentialsViewState();
}

class _PronunciationAssessmentCredentialsViewState
    extends State<PronunciationAssessmentCredentialsView> {
  bool _isProcessing = false;
  bool _obscureApiKey = true;
  late final TextEditingController _apiKeyController;
  late final TextEditingController _endpointController;

  @override
  void initState() {
    super.initState();
    final service = di<PronunciationAssessmentCredentialsService>();
    _apiKeyController = TextEditingController(text: service.apiKey.value);
    _endpointController = TextEditingController(text: service.endpoint.value);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _endpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pronunciation Assessment')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureApiKey,
            decoration: InputDecoration(
              labelText: 'API Key',
              suffixIcon: IconButton(
                icon: Icon(_obscureApiKey ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _endpointController,
            decoration: const InputDecoration(labelText: 'Endpoint'),
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: Listenable.merge([_apiKeyController, _endpointController]),
            builder: (context, child) {
              final bool canContinue = _apiKeyController.text.isNotEmpty &&
                  _endpointController.text.isNotEmpty &&
                  !_isProcessing;
              return ElevatedButton(
                onPressed: canContinue
                    ? () {
                        setState(() => _isProcessing = true);
                        final service = di<PronunciationAssessmentCredentialsService>();
                        service.apiKey.value = _apiKeyController.text;
                        service.endpoint.value = _endpointController.text;
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
