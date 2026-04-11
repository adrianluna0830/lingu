import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:lingu/core/pronunciation/service/i_pronunciation_assessment.dart';

import '../../models/pronunciation_assessment_errors.dart';
import '../../models/raw_pronunciation_assessment_response.dart';


class WebViewPronunciationAssessmentService implements IPronunciationAssessmentService {
  HeadlessInAppWebView? _headlessWebView;
  InAppWebViewController? _webViewController;
  Completer<Map<String, dynamic>>? _assessmentCompleter;
  bool _isEvaluating = false;

  WebViewPronunciationAssessmentService._();

  static Future<WebViewPronunciationAssessmentService> create({
    required String subscriptionKey,
    required String endpoint,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    if (subscriptionKey.trim().isEmpty) {
      throw const InvalidParametersError('subscriptionKey cannot be empty');
    }
    if (endpoint.trim().isEmpty) {
      throw const InvalidParametersError('endpoint cannot be empty');
    }

    final service = WebViewPronunciationAssessmentService._();

    try {
      await service._initialize(
        subscriptionKey: subscriptionKey,
        endpoint: endpoint,
        timeout: timeout,
      );
      return service;
    } catch (e) {
      service.dispose();
      if (e is TimeoutException) {
        throw InitializationTimeoutError('Initialization timed out after ${timeout.inSeconds}s');
      }
      throw ServiceCreationError('Error creating the service: $e');
    }
  }

  static const String _htmlContent = '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pronunciation Assessment</title>
    <script src="https://cdn.jsdelivr.net/npm/microsoft-cognitiveservices-speech-sdk@latest/distrib/browser/microsoft.cognitiveservices.speech.sdk.bundle-min.js"></script>
</head>
<body>
    <script>
        let speechConfig = null;
        let recognizer = null;
        
        function initializeSpeech(subscriptionKey, endpoint) {
            try {
                speechConfig = SpeechSDK.SpeechConfig.fromEndpoint(new URL(endpoint), subscriptionKey);
                speechConfig.requestWordLevelTimestamps();
                window.flutter_inappwebview.callHandler('initialized', { success: true });
            } catch (error) {
                window.flutter_inappwebview.callHandler('initializationError', { error: error.message });
            }
        }
        
        function assessPronunciationFromWav(
            audioBase64,
            sampleRate,
            bitsPerSample,
            channels,
            language,
            referenceText,
            gradingSystem,
            granularity,
            phonemeAlphabet,
            nBestPhonemeCount,
            enableMiscue,
            enableProsodyAssessment
        ) {
            if (!speechConfig) {
                window.flutter_inappwebview.callHandler('error', { error: 'SDK not initialized' });
                return;
            }
            
            try {
                speechConfig.speechRecognitionLanguage = language;

                const configJson = {
                    referenceText: referenceText,
                    gradingSystem: gradingSystem,
                    granularity: granularity,
                    phonemeAlphabet: phonemeAlphabet,
                    nBestPhonemeCount: nBestPhonemeCount,
                    enableMiscue: enableMiscue,
                };
                const pronunciationConfig = SpeechSDK.PronunciationAssessmentConfig.fromJSON(
                    JSON.stringify(configJson)
                );

                if (enableProsodyAssessment) {
                    pronunciationConfig.enableProsodyAssessment();
                }
                
                const binaryString = atob(audioBase64);
                const bytes = new Uint8Array(binaryString.length);
                for (let i = 0; i < binaryString.length; i++) {
                    bytes[i] = binaryString.charCodeAt(i);
                }
                
                const audioFormat = SpeechSDK.AudioStreamFormat.getWaveFormatPCM(sampleRate, bitsPerSample, channels);
                const pushStream = SpeechSDK.AudioInputStream.createPushStream(audioFormat);
                pushStream.write(bytes.buffer);
                pushStream.close();
                
                const audioConfig = SpeechSDK.AudioConfig.fromStreamInput(pushStream);
                recognizer = new SpeechSDK.SpeechRecognizer(speechConfig, audioConfig);
                pronunciationConfig.applyTo(recognizer);
                
                recognizer.recognizeOnceAsync(
                    (result) => {
                        if (result.reason === SpeechSDK.ResultReason.RecognizedSpeech) {
                            const fullJsonResult = result.properties.getProperty(
                                SpeechSDK.PropertyId.SpeechServiceResponse_JsonResult
                            );
                            window.flutter_inappwebview.callHandler('assessmentComplete', { fullJsonResult });
                        } else if (result.reason === SpeechSDK.ResultReason.NoMatch) {
                            window.flutter_inappwebview.callHandler('error', { error: 'No se pudo reconocer el audio' });
                        } else if (result.reason === SpeechSDK.ResultReason.Canceled) {
                            const cancellation = SpeechSDK.CancellationDetails.fromResult(result);
                            window.flutter_inappwebview.callHandler('error', { error: 'Reconocimiento cancelado: ' + cancellation.reason });
                        }
                        if (recognizer) { recognizer.close(); recognizer = null; }
                    },
                    (error) => {
                        window.flutter_inappwebview.callHandler('error', { error: 'Error: ' + error });
                        if (recognizer) { recognizer.close(); recognizer = null; }
                    }
                );
            } catch (error) {
                window.flutter_inappwebview.callHandler('error', { error: 'Excepción: ' + error.message });
            }
        }
    </script>
</body>
</html>
  ''';

  Future<void> _initialize({
    required String subscriptionKey,
    required String endpoint,
    required Duration timeout,
  }) async {
    final initCompleter = Completer<void>();

    _headlessWebView = HeadlessInAppWebView(
      initialData: InAppWebViewInitialData(data: _htmlContent, encoding: 'utf-8'),
      initialSettings: InAppWebViewSettings(
        mediaPlaybackRequiresUserGesture: false,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        javaScriptEnabled: true,
      ),
      onWebViewCreated: (controller) {
        _webViewController = controller;
        _registerHandlers(controller, initCompleter);
      },
      onLoadStop: (controller, url) async {
        await controller.evaluateJavascript(
          source: "initializeSpeech('$subscriptionKey', '$endpoint');",
        );
      },
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
    );

    await _headlessWebView?.run();

    await initCompleter.future.timeout(
      timeout,
      onTimeout: () => throw TimeoutException(
        'Service initialization timed out after ${timeout.inSeconds}s',
      ),
    );
  }

  void _registerHandlers(InAppWebViewController controller, Completer<void> initCompleter) {
    controller.addJavaScriptHandler(
      handlerName: 'initialized',
      callback: (_) {
        if (!initCompleter.isCompleted) initCompleter.complete();
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'initializationError',
      callback: (args) {
        final error = (args[0] as Map<String, dynamic>)['error'] as String;
        if (!initCompleter.isCompleted) {
          initCompleter.completeError(Exception('Error initializing Speech SDK: $error'));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'assessmentComplete',
      callback: (args) {
        _isEvaluating = false;
        if (_assessmentCompleter == null || _assessmentCompleter!.isCompleted) return;

        try {
          final raw = jsonDecode((args[0] as Map<String, dynamic>)['fullJsonResult'] as String) as Map<String, dynamic>;
          if (_isValidAssessmentResult(raw)) {
            _assessmentCompleter!.complete(raw);
          } else {
            _assessmentCompleter!.completeError(const AssessmentError('Invalid or incomplete response JSON'));
          }
        } catch (e) {
          _assessmentCompleter!.completeError(AssessmentError('Error parsing response: $e'));
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'error',
      callback: (args) {
        final error = (args[0] as Map<String, dynamic>)['error'] as String;
        _isEvaluating = false;
        if (_assessmentCompleter != null && !_assessmentCompleter!.isCompleted) {
          _assessmentCompleter!.completeError(AssessmentError(error));
        }
      },
    );
  }

  bool _isValidAssessmentResult(Map<String, dynamic> json) {
    return json.containsKey('NBest') &&
        json.containsKey('RecognitionStatus') &&
        json['NBest'] is List &&
        (json['NBest'] as List).isNotEmpty;
  }

  @override
  Future<RawPronunciationAssessmentResponse> assessFromWavAsync(
    {required Uint8List wavBytes,
    required String language,
    int sampleRate = 16000,
    int bitsPerSample = 16,
    int channels = 1,
    String referenceText = '',
    String gradingSystem = 'HundredMark',
    String granularity = 'Phoneme',
    String phonemeAlphabet = 'IPA',
    int nBestPhonemeCount = 1,
    bool enableMiscue = false,
    bool enableProsodyAssessment = false,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (_webViewController == null) throw const ServiceNotInitializedError();
    if (_isEvaluating) throw const EvaluationInProgressError();
    if (wavBytes.isEmpty) throw const InvalidAudioError('The WAV file cannot be empty');
    if (wavBytes.length < 44) throw const InvalidAudioError('Invalid WAV file: too small');

    _isEvaluating = true;
    _assessmentCompleter = Completer<Map<String, dynamic>>();

    try {
      final audioBase64 = base64Encode(wavBytes);
      final safeReferenceText = referenceText.replaceAll("'", "\\'");

      await _webViewController!.evaluateJavascript(
        source: """
          assessPronunciationFromWav(
            '$audioBase64',
            $sampleRate,
            $bitsPerSample,
            $channels,
            '$language',
            '$safeReferenceText',
            '$gradingSystem',
            '$granularity',
            '$phonemeAlphabet',
            $nBestPhonemeCount,
            $enableMiscue,
            $enableProsodyAssessment
          );
        """,
      );

      final raw = await _assessmentCompleter!.future.timeout(
        timeout,
        onTimeout: () {
          _isEvaluating = false;
          throw AssessmentTimeoutError('Evaluation timed out after ${timeout.inSeconds}s');
        },
      );

      return RawPronunciationAssessmentResponse.fromMap(raw);
    } catch (e) {
      _isEvaluating = false;
      if (e is PronunciationAssessmentUsageError) rethrow;
      if (e is TimeoutException) {
        throw AssessmentTimeoutError('Evaluation timed out after ${timeout.inSeconds}s');
      }
      throw AssessmentError('Error in assessment: $e');
    }
  }

  @override
  Future<void> dispose() async {
    _headlessWebView?.dispose();
    _webViewController?.dispose();
    _headlessWebView = null;
    _webViewController = null;
    _assessmentCompleter = null;
    _isEvaluating = false;
  }
}