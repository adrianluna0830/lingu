import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:lingu/core/audio/record/i_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' as rec;
import 'package:signals/signals.dart';
@Singleton(as: IAudioRecorder)
class AudioRecorder extends IAudioRecorder {
  final rec.AudioRecorder _recorder = rec.AudioRecorder();
  final StreamController<Amplitude> _amplitudeController =
      StreamController<Amplitude>.broadcast();
  Timer? _amplitudeTimer;
  String? _currentPath;

  final Signal<bool> _isRecording = signal(false);

  AudioRecorder() : super(pollingRate: kDefaultPollingRate);

  @override
  ReadonlySignal<bool> get isRecording => _isRecording;

  @override
  Stream<Amplitude> get onAmplitudeChanged => _amplitudeController.stream;

  @override
  Future<void> start() async {
    if (!await _recorder.hasPermission()) {
      throw Exception('Microphone permission not granted');
    }

    final dir = await getTemporaryDirectory();
    _currentPath =
        '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const rec.RecordConfig(
        encoder: rec.AudioEncoder.aacLc,
        numChannels: 1,
      ),
      path: _currentPath!,
    );

    _isRecording.value = true;

    _amplitudeTimer = Timer.periodic(pollingRate, (_) async {
      final amp = await _recorder.getAmplitude();
      _amplitudeController.add(Amplitude(
        value: amp.current,
        maxValue: amp.max,
      ));
    });
  }

  @override
  Future<Uint8List> stop() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;

    final path = await _recorder.stop();

    _isRecording.value = false;

    if (path == null) {
      throw Exception('Recording stopped but no file was produced');
    }

    final file = File(path);
    final bytes = await file.readAsBytes();
    await file.delete();
    return bytes;
  }

  @override
  Future<void> pause() async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    await _recorder.pause();
    _isRecording.value = false;
  }

  @override
  Future<void> resume() async {
    await _recorder.resume();

    _isRecording.value = true;

    _amplitudeTimer = Timer.periodic(pollingRate, (_) async {
      final amp = await _recorder.getAmplitude();
      _amplitudeController.add(Amplitude(
        value: amp.current,
        maxValue: amp.max,
      ));
    });
  }

  @override
  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    await _amplitudeController.close();
    _isRecording.value = false;
    _recorder.dispose();
  }
  
  @override
  Future<String> stopAndGetFilePath({String? directory, String? fileName}) async {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = null;
    final path = await _recorder.stop();
    _isRecording.value = false;
    if (path == null) {
      throw Exception('Recording stopped but no file was produced');
    }
    final targetDir = directory != null
        ? Directory(directory)
        : await getTemporaryDirectory();
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }
    final name =
        fileName ?? 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final targetPath = '${targetDir.path}/$name';
    await File(path).rename(targetPath);
    return targetPath;
  }
}