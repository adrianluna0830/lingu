import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:lingu/features/chat/ui/chat_messages_list/widgets/message_layout.dart';

class AITextMessage extends StatefulWidget {
  final String text;
  final String? translation;
  final VoidCallback onTap;
  final VoidCallback onTranslation;

  const AITextMessage({super.key, required this.text, this.translation, required this.onTap, required this.onTranslation});

  @override
  State<AITextMessage> createState() => _AITextMessageState();
}

class _AITextMessageState extends State<AITextMessage> with SignalsMixin {
  late final _showTranslation = createSignal(false);

  @override
  Widget build(BuildContext context) {
    final isShowing = _showTranslation.watch(context);

    return MessageLayout(
      alignment: Alignment.centerLeft,
      onLongPress: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.text),
            if (isShowing) ...[
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _showTranslation.value = false,
                borderRadius: BorderRadius.circular(4),
                child: Text(
                  widget.translation != null ? '"${widget.translation}"' : '"Cargando..."',
                  style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87, fontSize: 12),
                ),
              ),
            ] else ...[
              const SizedBox(height: 4),
              InkWell(
                onTap: () {
                  _showTranslation.value = true;
                  widget.onTranslation();
                },
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Icon(Icons.translate_rounded, size: 16, color: Colors.black38),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
