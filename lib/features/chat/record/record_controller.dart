import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';

class RecordController {
  final StreamController<Amplitude> _amplitudeStreamController = StreamController<Amplitude>.broadcast();
  Stream<Amplitude> get amplitudeStream => _amplitudeStreamController.stream;

  final VoidCallback onStart;
  final VoidCallback onStop;
  final VoidCallback onCancel;

  RecordController({required this.onStart, required this.onStop, required this.onCancel});
  void updateAmplitude(Amplitude amplitude) => _amplitudeStreamController.add(amplitude);
  

  void startRecording() => onStart();

  void stopRecording() => onStop(); 

  void cancelRecording() => onCancel();

  void dispose() => _amplitudeStreamController.close();
  
}
