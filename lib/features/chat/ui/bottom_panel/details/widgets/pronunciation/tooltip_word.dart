import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lingu/core/audio/playback/i_audio_playback.dart';
import 'package:lingu/core/di/injection.dart';
import 'package:lingu/core/utils/ui_utils.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart' as model;
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/pronunciation/syllable_widget.dart';
import 'package:signals/signals_flutter.dart';
import 'package:super_tooltip/super_tooltip.dart';

class TooltipWord extends StatefulWidget {
  final model.WordPronunciationFeedback feedback;

  const TooltipWord({super.key, required this.feedback});

  @override
  State<TooltipWord> createState() => _TooltipWordState();
}

class _TooltipWordState extends State<TooltipWord> {
  final _tooltipController = SuperTooltipController();
  late final _feedbackController = WordFeedbackTooltipInternalController(widget.feedback);

  @override
  void dispose() {
    _tooltipController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wordColor = getErrorSeverityColor(widget.feedback.detail?.mostSevere);
    final defaultStyle = DefaultTextStyle.of(context).style.copyWith(fontSize: 16);

    return SuperTooltip(
      style: const TooltipStyle(backgroundColor: Colors.white, borderColor: Colors.black, borderWidth: 1),
      positionConfig: const PositionConfiguration(preferredDirection: TooltipDirection.down),
      controller: _tooltipController,
      content: WordPronunciationFeedbackDetails(controller: _feedbackController),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _tooltipController.showTooltip(),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(widget.feedback.word, style: defaultStyle.copyWith(color: wordColor)),
          ),
        ),
      ),
    );
  }
}

sealed class AudioSelectionState {
  final bool isUser;

  AudioSelectionState({required this.isUser});
}

class UserSyllableSelection extends AudioSelectionState {
  final int syllableIndex;
  UserSyllableSelection({required this.syllableIndex}) : super(isUser: true);
}

class UserWordSelection extends AudioSelectionState {
  UserWordSelection() : super(isUser: true);
}

class AISyllableSelection extends AudioSelectionState {
  final int syllableIndex;
  AISyllableSelection({required this.syllableIndex}) : super(isUser: false);
}

class AIWordSelection extends AudioSelectionState {
  AIWordSelection() : super(isUser: false);
}

class WordFeedbackTooltipInternalController {
  late final IAudioPlayerManager _audioPlayerManager = di<IAudioPlayerManager>();
  final model.WordPronunciationFeedback feedback;
  WordFeedbackTooltipInternalController(this.feedback);

  final _audioSelection = signal<AudioSelectionState?>(null);
  ReadonlySignal<AudioSelectionState?> get audioSelection => _audioSelection;

  final _syllableFeedbackIndex = signal<({int index, String feedback})?>(null);
  ReadonlySignal<({int index, String feedback})?> get syllableFeedbackIndex => _syllableFeedbackIndex;
  String get fullWord => feedback.word;
  List<String> get syllables => feedback.detail?.syllableFeedback.map((s) => s.syllable).toList() ?? [];

  StreamSubscription<void>? _completionSubscription;

  void _listenToCompletion(String source) {
    _completionSubscription?.cancel();
    _completionSubscription = _audioPlayerManager.getOnCompletion(source).listen((_) {
      // Ensure we only clear if the current selection is still active
      _audioSelection.value = null;
    });
  }

  void selectUserSyllable(int index) {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.syllableFeedback[index].userPronunciationFilePath;
    // Force reset to ensure reactivity and cancel any previous state
    _audioSelection.value = null;
    _audioSelection.value = UserSyllableSelection(syllableIndex: index);
    _listenToCompletion(source);
    print('Reproduciendo UserSyllable desde: $source');
    _audioPlayerManager.play(source);
  }

  void selectUserWord() {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.userPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = UserWordSelection();

    _listenToCompletion(source);
    print('Reproduciendo UserWord desde: $source');
    _audioPlayerManager.play(source);
  }

  void selectAISyllable(int index) {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.syllableFeedback[index].correctPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = AISyllableSelection(syllableIndex: index);
    _listenToCompletion(source);
    print('Reproduciendo AISyllable desde: $source');
    _audioPlayerManager.play(source);
  }

  void selectAIWord() {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.correctPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = AIWordSelection();
    _listenToCompletion(source);
    print('Reproduciendo AIWord desde: $source');
    _audioPlayerManager.play(source);
  }

  void setSyllableFeedbackIndex(int index) {
    final current = _syllableFeedbackIndex.value;
    final syllableDetail = feedback.detail?.syllableFeedback[index].detail;

    if (current != null && index == current.index) {
      _syllableFeedbackIndex.value = null;
    } else {
      _syllableFeedbackIndex.value = (index: index, feedback: syllableDetail?.feedbackMessage ?? "No feedback available");
    }
  }

  void dispose() {
    _completionSubscription?.cancel();
  }
}

class WordFeedbackTooltip extends StatefulWidget {
  final model.WordPronunciationFeedback feedback;

  const WordFeedbackTooltip({super.key, required this.feedback});

  @override
  State<WordFeedbackTooltip> createState() => _WordFeedbackTooltipState();
}

class _WordFeedbackTooltipState extends State<WordFeedbackTooltip> {
  late final WordFeedbackTooltipInternalController _controller = WordFeedbackTooltipInternalController(widget.feedback);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WordPronunciationFeedbackDetails(controller: _controller);
  }
}

class WordPronunciationFeedbackDetails extends StatelessWidget {
  final WordFeedbackTooltipInternalController controller;

  const WordPronunciationFeedbackDetails({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final selection = controller.audioSelection.watch(context);
    final feedbackIdx = controller.syllableFeedbackIndex.watch(context);
    final syllablesData = controller.feedback.detail?.syllableFeedback ?? [];

    const double inactiveOpacity = 0.35;
    const double feedbackBoxHeight = 80.0;

    return SizedBox(
      width: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Usuario
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Icon(Icons.person_pin, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.syllables.length > 1) ...[
                          Opacity(
                            opacity: selection is UserWordSelection ? 1.0 : inactiveOpacity,
                            child: FeedbackItem(text: controller.fullWord, isSelected: selection is UserWordSelection, onTap: () => controller.selectUserWord()),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            for (int i = 0; i < controller.syllables.length; i++)
                              Opacity(
                                opacity: selection is UserSyllableSelection && selection.syllableIndex == i ? 1.0 : inactiveOpacity,
                                child: FeedbackItem(
                                  text: controller.syllables[i],
                                  isSelected: selection is UserSyllableSelection && selection.syllableIndex == i,
                                  onTap: () => controller.selectUserSyllable(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 12),
              // IA
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Icon(Icons.auto_awesome, size: 18, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.syllables.length > 1) ...[
                          Opacity(
                            opacity: selection is AIWordSelection ? 1.0 : inactiveOpacity,
                            child: FeedbackItem(text: controller.fullWord, isSelected: selection is AIWordSelection, onTap: () => controller.selectAIWord()),
                          ),
                          const SizedBox(height: 2),
                        ],
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: [
                            for (int i = 0; i < controller.syllables.length; i++)
                              Opacity(
                                opacity: selection is AISyllableSelection && selection.syllableIndex == i ? 1.0 : inactiveOpacity,
                                child: FeedbackItem(
                                  text: controller.syllables[i],
                                  isSelected: selection is AISyllableSelection && selection.syllableIndex == i,
                                  onTap: () => controller.selectAISyllable(i),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (syllablesData.isNotEmpty) ...[
                const Divider(height: 12),
                // Análisis
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2,
                      runSpacing: 2,
                      children: [
                        for (int i = 0; i < syllablesData.length; i++)
                          Opacity(
                            opacity: feedbackIdx?.index == i ? 1.0 : inactiveOpacity,
                            child: FeedbackItem(
                              text: syllablesData[i].syllable,
                              isSelected: feedbackIdx?.index == i,
                              onTap: syllablesData[i].detail != null ? () => controller.setSyllableFeedbackIndex(i) : null,
                              color: syllablesData[i].detail != null ? getErrorSeverityColor(syllablesData[i].detail?.severity) : Colors.black,
                            ),
                          ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: feedbackBoxHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(6),
                        child: feedbackIdx != null
                            ? Text(
                                feedbackIdx.feedback,
                                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FeedbackItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? color;

  const FeedbackItem({super.key, required this.text, required this.isSelected, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        text,
        style: TextStyle(color: color ?? Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 16, decoration: TextDecoration.none),
      ),
    );

    if (onTap == null) {
      return container;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      hoverColor: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
      splashColor: color?.withOpacity(0.2) ?? Colors.blue.withOpacity(0.2),
      highlightColor: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
      child: container,
    );
  }
}
