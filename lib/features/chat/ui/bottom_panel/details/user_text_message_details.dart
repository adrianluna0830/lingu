import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/base_message_details_options.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/base_message_details_panel.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/widgets/message_feedback_content.dart';

enum UserTextMessageOptions { fluency, grammar }

class UserTextMessageDetails extends BaseMessageDetailsPanel<UserTextMessageOptions> {
  final UserTextMessageDetailsViewDto data;

  const UserTextMessageDetails({super.key, required this.data});

  @override
  State<UserTextMessageDetails> createState() => _UserTextMessageDetailsState();
}

class _UserTextMessageDetailsState extends BaseMessageDetailsPanelState<UserTextMessageOptions, UserTextMessageDetails> {

  @override
  Widget buildHeader(BuildContext context) {
    if (widget.data.translatedText == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your message',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.data.translatedText!.targetText,
            style: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  List<Option<UserTextMessageOptions>> getOptions() {
    return [
      Option(
        value: UserTextMessageOptions.grammar,
        isEnabled: widget.data.grammarFeedback != null,
        onPressed: () => selectedOption.value = UserTextMessageOptions.grammar,
      ),
      Option(
        value: UserTextMessageOptions.fluency,
        isEnabled: widget.data.fluencyFeedback != null,
        onPressed: () => selectedOption.value = UserTextMessageOptions.fluency,
      ),
    ];
  }

  @override
  String getOptionTitle(UserTextMessageOptions option, BuildContext context) {
    return switch (option) {
      UserTextMessageOptions.grammar => 'Grammar',
      UserTextMessageOptions.fluency => 'Fluency',
    };
  }

  @override
  Widget getOptionContent(UserTextMessageOptions selected) {
    final feedback = switch (selected) {
      UserTextMessageOptions.grammar => widget.data.grammarFeedback,
      UserTextMessageOptions.fluency => widget.data.fluencyFeedback,
    };

    if (feedback == null) return const SizedBox.shrink();

    return MessageFeedbackContent(
      correction: feedback.correction,
      explanation: feedback.explanation,
    );
  }
}
