import 'package:flutter/material.dart';
import 'package:lingu/presentation/widgets/interactive_selectable_text.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/presentation/screens/chat/widgets/messages/message_layout.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AITextMessage extends StatefulWidget {
  final String text;
  final String? translation;
  final VoidCallback onTap;
  final VoidCallback onTranslation;
  final VoidCallback? onWordInfo;
  final VoidCallback? onChat;

  const AITextMessage({
    super.key,
    required this.text,
    this.translation,
    required this.onTap,
    required this.onTranslation,
    this.onWordInfo,
    this.onChat,
  });

  @override
  State<AITextMessage> createState() => _AITextMessageState();
}

class _AITextMessageState extends State<AITextMessage> with SignalsMixin {
  late final _showTranslation = createSignal(false);

  @override
  Widget build(BuildContext context) {
    final isShowing = _showTranslation.watch(context);

    return MessageLayout(
      isUser: false,
      onLongPress: widget.onTap,
      footerActions: [
        InkWell(
          onTap: () {
            if (isShowing) {
              _showTranslation.value = false;
            } else {
              _showTranslation.value = true;
              widget.onTranslation();
            }
          },
          borderRadius: BorderRadius.circular(4),
          child: Icon(Icons.translate_rounded, size: 16, color: isShowing ? Colors.blue : Colors.black38),
        ),
      ],
      children: [
        InteractiveSelectableText(
          text: widget.text,
          onChat: widget.onChat ?? () {},
          onWordInfo: widget.onWordInfo ?? () {},
        ),
        if (isShowing)
          widget.translation != null
              ? MessageSubText(
                  '"${widget.translation}"',
                  onTap: () => _showTranslation.value = false,
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Shimmer(
                    child: Container(
                      height: 12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
      ],
    );
  }
}
