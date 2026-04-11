import 'package:flutter/material.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:signals/signals_flutter.dart';
import 'package:waveform_flutter/waveform_flutter.dart' as waveform;

class LanguageAmplitude extends waveform.Amplitude {
  final bool isTarget;
  LanguageAmplitude({
    required super.current,
    required super.max,
    required this.isTarget,
  });
}

class RecordDisplay extends StatefulWidget {
  final RecordController? controller;
  final Stream<(double, double)> amplitudeStream;
  final LanguageLocale nativeLocale;
  final LanguageLocale targetLocale;

  const RecordDisplay({
    super.key,
    this.controller,
    required this.amplitudeStream,
    required this.nativeLocale,
    required this.targetLocale,
  });

  @override
  State<RecordDisplay> createState() => _RecordDisplayState();
}

class _RecordDisplayState extends State<RecordDisplay> {
  late final RecordInternalController _internalController = RecordInternalController(controller: widget.controller);
  late Stream<waveform.Amplitude> _waveformStream;

  @override
  void initState() {
    super.initState();
    _initStream();
    _internalController.startRecording();
  }

  void _initStream() {
    _waveformStream = widget.amplitudeStream.map(
      (amp) => LanguageAmplitude(
        current: amp.$1,
        max: amp.$2,
        isTarget: _internalController.speakingTargetLanguage.value,
      ),
    );
  }

  @override
  void didUpdateWidget(RecordDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.amplitudeStream != widget.amplitudeStream ||
        oldWidget.controller != widget.controller) {
      _initStream();
    }
  }

  String _getLocaleDisplay(LanguageLocale locale) {
    switch (locale) {
      case LanguageLocale.en:
        return 'En';
      case LanguageLocale.es:
        return 'Es';
      case LanguageLocale.de:
        return 'De';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTargetLanguage =
        _internalController.speakingTargetLanguage.watch(context);
    final isPaused = _internalController.isPaused.watch(context);

    final currentLocale = isTargetLanguage ? widget.targetLocale : widget.nativeLocale;
    final localeName = _getLocaleDisplay(currentLocale);

    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              waveform.AnimatedWaveList(
                stream: _waveformStream,
                barBuilder: (animation, amplitude) {
                  final isTarget = (amplitude is LanguageAmplitude)
                      ? amplitude.isTarget
                      : true;
                  return waveform.WaveFormBar(
                    animation: animation,
                    amplitude: amplitude,
                    color: isTarget ? Colors.red : Colors.blue,
                  );
                },
              ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 2.5,
                    ),
                  ),
                  child: Text(
                    localeName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _internalController.cancelRecording,
              icon: const Icon(Icons.cancel),
            ),
            IconButton(
              onPressed: _internalController.toggleRecording,
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            ),
            IconButton(
              onPressed: _internalController.toggleLanguage,
              icon: Icon(
                isTargetLanguage ? Icons.language : Icons.translate,
              ),
            ),
            IconButton(
              onPressed: _internalController.stopRecording,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ],
    );
  }
}
