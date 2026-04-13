import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  final Alignment alignment;
  final VoidCallback? onLongPress;
  final Widget child;
  final Decoration? decoration;

  const MessageLayout({
    super.key,
    required this.alignment,
    this.onLongPress,
    required this.child,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          decoration: decoration,
          child: Material(
            color: Colors.blue[200],
            borderRadius: BorderRadius.circular(8.0),
            child: InkWell(
              onLongPress: onLongPress,
              borderRadius: BorderRadius.circular(8.0),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
