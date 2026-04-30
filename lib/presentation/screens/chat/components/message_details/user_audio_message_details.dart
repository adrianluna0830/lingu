import 'package:flutter/material.dart';
import 'package:lingu/domain/chat/models/enums/feedback_result_enum.dart';
import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';
import 'package:lingu/presentation/screens/chat/widgets/feedback/audio_pronunciation_content.dart';
import 'package:lingu/presentation/screens/chat/components/message_details/base_message_details_options.dart';
import 'package:lingu/presentation/screens/chat/components/message_details/base_message_details_panel.dart';
import 'package:lingu/presentation/screens/chat/widgets/feedback/message_feedback_content.dart';

enum UserAudioMessageOptions { fluency, grammar, pronunciation }

class UserAudioMessageDetails extends BaseMessageDetailsPanel<UserAudioMessageOptions> {
  final UserAudioDetails data;
  const UserAudioMessageDetails({super.key, required this.data});

  @override
  State<UserAudioMessageDetails> createState() => _UserAudioMessageDetailsState();
}

class _UserAudioMessageDetailsState extends BaseMessageDetailsPanelState<UserAudioMessageOptions, UserAudioMessageDetails> {

  @override
  Widget buildHeader(BuildContext context) {
    if (widget.data.translatedText == null) return const SizedBox.shrink();
    
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

  @override
  List<Option<UserAudioMessageOptions>> getOptions() {
    final p = widget.data.pronunciationFeedback;
    final showPronunciation = p != null && (p.fluencyFeedback != null || p.mostSevere != FeedbackResultEnum.none);

    return [
      Option(
        value: UserAudioMessageOptions.grammar,
        isEnabled: widget.data.grammarFeedback != null,
        onPressed: () => selectedOption.value = UserAudioMessageOptions.grammar,
      ),
      Option(
        value: UserAudioMessageOptions.fluency,
        isEnabled: widget.data.fluencyFeedback != null,
        onPressed: () => selectedOption.value = UserAudioMessageOptions.fluency,
      ),
      Option(
        value: UserAudioMessageOptions.pronunciation,
        isEnabled: showPronunciation,
        onPressed: () => selectedOption.value = UserAudioMessageOptions.pronunciation,
      ),
    ];
  }

  @override
  String getOptionTitle(UserAudioMessageOptions option, BuildContext context) {
    return option.name.toUpperCase();
  }

  @override
  Widget getOptionContent(UserAudioMessageOptions selected) {
    if (selected == UserAudioMessageOptions.pronunciation) {
      final p = widget.data.pronunciationFeedback!;
      return AudioPronunciationContent(
        results: p.itemResults,
        fluencyFeedback: p.fluencyFeedback,
      );
    }

    final feedback = selected == UserAudioMessageOptions.grammar 
        ? widget.data.grammarFeedback 
        : widget.data.fluencyFeedback;
        
    if (feedback == null) return const SizedBox.shrink();

    return MessageFeedbackContent(
      correction: feedback.correction,
      explanation: feedback.explanation,
    );
  }
}
