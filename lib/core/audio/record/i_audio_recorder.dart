import 'dart:async';
import 'dart:typed_data';
import 'package:signals/signals.dart';

const Duration kDefaultPollingRate = Duration(milliseconds: 100);

class Amplitude {
  final double value;
  final double maxValue;
  Amplitude({required this.value, required this.maxValue});
}

abstract class IAudioRecorder {
  final Duration pollingRate;

  IAudioRecorder({required this.pollingRate});

  ReadonlySignal<bool> get isRecording;
  Stream<Amplitude> get onAmplitudeChanged;
  Future<void> start();
  Future<Uint8List> stop();
  Future<void> pause();
  Future<void> resume();
  Future<void> dispose();
}
