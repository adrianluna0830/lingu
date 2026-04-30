import 'dart:async';
import 'package:lingu/domain/audio/managers/audio_player_manager.dart';
import 'package:lingu/domain/interfaces/audio_playback/i_audio_playback.dart';
import 'package:lingu/domain/core/di/injection.dart';
import 'package:lingu/domain/chat/models/feedback/pronunciation_feedback.dart' as model;
import 'package:signals/signals_flutter.dart';

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

class WordFeedbackController {
  late final AudioPlayerManager _audioPlayerManager = di<AudioPlayerManager>();
  final model.WordPronunciationFeedback feedback;
  WordFeedbackController(this.feedback);

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
      _audioSelection.value = null;
    });
  }

  void selectUserSyllable(int index) {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.syllableFeedback[index].userPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = UserSyllableSelection(syllableIndex: index);
    _listenToCompletion(source);
    _audioPlayerManager.play(source);
  }

  void selectUserWord() {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.userPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = UserWordSelection();

    _listenToCompletion(source);
    _audioPlayerManager.play(source);
  }

  void selectAISyllable(int index) {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.syllableFeedback[index].correctPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = AISyllableSelection(syllableIndex: index);
    _listenToCompletion(source);
    _audioPlayerManager.play(source);
  }

  void selectAIWord() {
    final detail = feedback.detail;
    if (detail == null) return;
    final source = detail.correctPronunciationFilePath;
    _audioSelection.value = null;
    _audioSelection.value = AIWordSelection();
    _listenToCompletion(source);
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
