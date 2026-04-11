import 'package:signals/signals_flutter.dart';

class RecordController {
  Function()? onStart;
  Function()? onStop;
  Function()? onCancel;
  Function(bool isTargetLanguage)? onToggleLanguage;
  Function(bool isPaused)? onToggleRecording;
}

class RecordInternalController {
  final RecordController? controller;

  RecordInternalController({this.controller});

  final _speakingTargetLanguage = signal(true);
  ReadonlySignal<bool> get speakingTargetLanguage => _speakingTargetLanguage;

  final _isPaused = signal(false);
  ReadonlySignal<bool> get isPaused => _isPaused;

  void toggleLanguage() {
    _speakingTargetLanguage.value = !_speakingTargetLanguage.value;
    controller?.onToggleLanguage?.call(_speakingTargetLanguage.value);
  }

  void startRecording() {
    _isPaused.value = false;
    controller?.onStart?.call();
  }

  void stopRecording() {
    _isPaused.value = false;
    controller?.onStop?.call();
  }

  void cancelRecording() {
    _isPaused.value = false;
    controller?.onCancel?.call();
  }

  void toggleRecording() {
    _isPaused.value = !_isPaused.value;
    controller?.onToggleRecording?.call(_isPaused.value);
  }

  void dispose() {}
}
