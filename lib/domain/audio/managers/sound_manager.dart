import 'package:signals/signals.dart';

enum SoundSpeedLevel {
  slower,
  slow,
  normal,
  fast,
  faster;

  double get value {
    switch (this) {
      case SoundSpeedLevel.slower:
        return 0.6;
      case SoundSpeedLevel.slow:
        return 0.8;
      case SoundSpeedLevel.normal:
        return 1.0;
      case SoundSpeedLevel.fast:
        return 1.2;
      case SoundSpeedLevel.faster:
        return 1.5;
    }
  }
}

class SoundManager {
  final _volumeSignal = signal<double>(1.0);
  final _speedSignal = signal<SoundSpeedLevel>(SoundSpeedLevel.normal);

  ReadonlySignal<double> get volumeSignal => _volumeSignal;
  ReadonlySignal<SoundSpeedLevel> get speedSignal => _speedSignal;

  void setVolume(double volume) {
    _volumeSignal.value = volume;
  }

  void setSlower() {
    _speedSignal.value = SoundSpeedLevel.slower;
  }

  void setSlow() {
    _speedSignal.value = SoundSpeedLevel.slow;
  }

  void setNormal() {
    _speedSignal.value = SoundSpeedLevel.normal;
  }

  void setFast() {
    _speedSignal.value = SoundSpeedLevel.fast;
  }

  void setFaster() {
    _speedSignal.value = SoundSpeedLevel.faster;
  }
}
