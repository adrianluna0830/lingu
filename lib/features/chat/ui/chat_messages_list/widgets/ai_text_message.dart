import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';
import 'package:lingu/features/home/ui/widgets/interactable_text.dart';

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
        InteractableText(
          text: widget.text,
          onChat: widget.onChat ?? () {},
          onWordInfo: widget.onWordInfo ?? () {},
        ),
        if (isShowing)
          MessageSubText(
            widget.translation != null ? '"${widget.translation}"' : '"Cargando..."',
            onTap: () => _showTranslation.value = false,
          ),
      ],
    );
  }
}
