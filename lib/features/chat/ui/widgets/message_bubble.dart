import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final Widget content;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.content,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue[200],
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(8.0),
        child: content,
      ),
    );
  }
}
