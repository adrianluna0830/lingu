import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/feedback_result_enum.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/logic/feedback/models/pronunciation_feedback.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/base_message_details_options.dart';
import 'package:signals/signals_flutter.dart';

enum UserAudioMessageOptions { fluency, grammar, pronunciation }

class UserAudioMessageDetails extends StatefulWidget {
  final UserAudioMessageDetailsViewDto data;
  const UserAudioMessageDetails({super.key, required this.data});

  @override
  State<UserAudioMessageDetails> createState() => _UserAudioMessageDetailsState();
}

class _UserAudioMessageDetailsState extends State<UserAudioMessageDetails> with SignalsMixin {
  late final _selectedOption = createSignal<UserAudioMessageOptions?>(null);

  @override
  Widget build(BuildContext context) {
    final selected = _selectedOption.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.data.translatedText != null) _buildOriginalMessage(),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: selected != null
                ? SingleChildScrollView(
                    key: ValueKey(selected),
                    padding: const EdgeInsets.all(16.0),
                    child: _buildSelectedContent(selected),
                  )
                : _buildPlaceholder(),
          ),
        ),
        _buildOptionsSelector(),
      ],
    );
  }

  Widget _buildOriginalMessage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your message', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Text(widget.data.translatedText!.targetText, style: const TextStyle(fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(child: Text('Select analysis type', style: TextStyle(color: Colors.grey)));
  }

  Widget _buildOptionsSelector() {
    final p = widget.data.pronunciationFeedback;
    final showPronunciation = p != null &&
        (p.observations != null || p.fluencyFeedback != null || p.mostSevere != FeedbackResultEnum.none);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: BaseMessageDetailsOptions<UserAudioMessageOptions>(
          segments: [
            (UserAudioMessageOptions.grammar, widget.data.grammarFeedback != null ? () => _selectedOption.value = UserAudioMessageOptions.grammar : null),
            (UserAudioMessageOptions.fluency, widget.data.fluencyFeedback != null ? () => _selectedOption.value = UserAudioMessageOptions.fluency : null),
            (UserAudioMessageOptions.pronunciation, showPronunciation ? () => _selectedOption.value = UserAudioMessageOptions.pronunciation : null),
          ],
          labelBuilder: (opt, _) => opt.name.toUpperCase(),
        ),
      ),
    );
  }

  Widget _buildSelectedContent(UserAudioMessageOptions selected) {
    if (selected == UserAudioMessageOptions.pronunciation) return _buildPronunciationContent();

    final feedback = selected == UserAudioMessageOptions.grammar ? widget.data.grammarFeedback : widget.data.fluencyFeedback;
    if (feedback == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(feedback.correction, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Text(feedback.explanation),
      ],
    );
  }

  Widget _buildPronunciationContent() {
    final p = widget.data.pronunciationFeedback!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (p.observations != null) ...[
          const Text('Observations', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(p.observations!),
          const SizedBox(height: 16),
        ],
        if (p.fluencyFeedback != null) ...[
          const Text('Fluency Feedback', style: TextStyle(fontWeight: FontWeight.bold)),
          Text(p.fluencyFeedback!),
        ],
      ],
    );
  }
}
