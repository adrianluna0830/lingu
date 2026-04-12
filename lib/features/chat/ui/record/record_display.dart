import 'package:flutter/material.dart';
import 'package:lingu/core/models/language_locale.dart';
import 'package:lingu/features/chat/ui/record/record_controller.dart';
import 'package:lingu/features/chat/ui/widgets/locale_indicator.dart';
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

 

  @override
  Widget build(BuildContext context) {
    final isTargetLanguage =
        _internalController.speakingTargetLanguage.watch(context);
    final isPaused = _internalController.isPaused.watch(context);

    final currentLocale = isTargetLanguage ? widget.targetLocale : widget.nativeLocale;

    return Column(
      children: [
        Expanded(
          child: waveform.AnimatedWaveList(
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
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  onPressed: _internalController.toggleLanguage,
                  icon: Icon(
                    isTargetLanguage ? Icons.language : Icons.translate,
                  ),
                ),
                Positioned(
                  top: -4,
                  right: -2,
                  child: IgnorePointer(
                    child: LocaleIndicator(locale: currentLocale),
                  ),
                ),
              ],
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
