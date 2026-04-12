import 'package:flutter/material.dart';
import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';
import 'package:lingu/features/chat/ui/bottom_panel/details/base_message_details_options.dart';
import 'package:signals/signals_flutter.dart';

enum UserTextMessageOptions { fluency, grammar }

class UserTextMessageDetails extends StatefulWidget {
  final UserTextMessageDetailsViewDto data;

  const UserTextMessageDetails({super.key, required this.data});

  @override
  State<UserTextMessageDetails> createState() => _UserTextMessageDetailsState();
}

class _UserTextMessageDetailsState extends State<UserTextMessageDetails> with SignalsMixin {
  late final _selectedOption = createSignal<UserTextMessageOptions?>(null);

  @override
  Widget build(BuildContext context) {
    final selected = _selectedOption.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Original Message Anchor
        if (widget.data.translatedText != null)
          Container(
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
          ),

        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: selected != null
                ? SingleChildScrollView(
                    key: ValueKey(selected),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: _buildSelectedContent(selected),
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.insights, size: 48, color: Colors.blue.shade100),
                        const SizedBox(height: 12),
                        Text(
                          'Select an analysis type below',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BaseMessageDetailsOptions<UserTextMessageOptions>(
              segments: [
                (
                  UserTextMessageOptions.grammar,
                  widget.data.grammarFeedback != null ? () => _selectedOption.value = UserTextMessageOptions.grammar : null
                ),
                (
                  UserTextMessageOptions.fluency,
                  widget.data.fluencyFeedback != null ? () => _selectedOption.value = UserTextMessageOptions.fluency : null
                ),
              ],
              labelBuilder: (option, context) => switch (option) {
                UserTextMessageOptions.grammar => 'Grammar',
                UserTextMessageOptions.fluency => 'Fluency',
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedContent(UserTextMessageOptions selected) {
    final feedback = switch (selected) {
      UserTextMessageOptions.grammar => widget.data.grammarFeedback,
      UserTextMessageOptions.fluency => widget.data.fluencyFeedback,
    };

    if (feedback == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(feedback.correction, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 8),
        Text(feedback.explanation, style: const TextStyle(fontSize: 16, color: Colors.black87)),
      ],
    );
  }
}
