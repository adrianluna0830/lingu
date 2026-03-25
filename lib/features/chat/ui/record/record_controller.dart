import 'dart:async';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:signals/signals_flutter.dart';

class RecordController {
  final StreamController<Amplitude> _amplitudeStreamController = StreamController<Amplitude>.broadcast();
  Stream<Amplitude> get amplitudeStream => _amplitudeStreamController.stream;

  Function()? onStart;
  Function()? onStop;
  Function()? onCancel;
  Function(bool isTargetLanguage)? onToggleLanguage;
  Function(bool isPaused)? onToggleRecording;

  final _speakingTargetLanguage = signal(true);
  ReadonlySignal get speakingTargetLanguage => _speakingTargetLanguage;

  final _isPaused = signal(false);
  ReadonlySignal<bool> get isPaused => _isPaused;

  void toggleLanguage()
  {
    _speakingTargetLanguage.value = !_speakingTargetLanguage.value;
    onToggleLanguage?.call(_speakingTargetLanguage.value);
  }

  void updateAmplitude(Amplitude amplitude) => _amplitudeStreamController.add(amplitude);
  

  void startRecording() {
    _isPaused.value = false;
    onStart?.call();
  }

  void stopRecording() {
    _isPaused.value = false;
    onStop?.call();
  } 

  void cancelRecording() {
    _isPaused.value = false;
    onCancel?.call();
  }

  void toggleRecording() {
    _isPaused.value = !_isPaused.value;
    onToggleRecording?.call(_isPaused.value);
  }

  void dispose() => _amplitudeStreamController.close();
  
}
