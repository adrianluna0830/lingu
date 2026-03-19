import 'dart:async';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';

class RecordController {
  final StreamController<Amplitude> _amplitudeStreamController = StreamController<Amplitude>.broadcast();
  Stream<Amplitude> get amplitudeStream => _amplitudeStreamController.stream;

  Function()? onStart;
  Function()? onStop;
  Function()? onCancel;

  void updateAmplitude(Amplitude amplitude) => _amplitudeStreamController.add(amplitude);
  

  void startRecording() => onStart?.call();

  void stopRecording() => onStop?.call(); 

  void cancelRecording() => onCancel?.call();

  void dispose() => _amplitudeStreamController.close();
  
}
