import 'package:flutter/material.dart';

class MessageLayout extends StatelessWidget {
  final bool isUser;
  final VoidCallback? onLongPress;
  final List<Widget> children;
  final List<Widget>? footerActions;
  final Decoration? decoration;

  const MessageLayout({
    super.key,
    required this.isUser,
    this.onLongPress,
    required this.children,
    this.footerActions,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.7),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: decoration,
              child: Material(
                color: isUser ? Colors.blue[200] : Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
                child: InkWell(
                  onLongPress: onLongPress,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                    child: Column(
                      crossAxisAlignment:
                          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ...children,
                        if (footerActions != null && footerActions!.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: footerActions!
                                .map((a) => Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: a,
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MessageSubText extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const MessageSubText(
    this.text, {
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Text(
        text,
        style: const TextStyle(
          fontStyle: FontStyle.italic,
          color: Colors.black87,
          fontSize: 12,
        ),
      ),
    );
  }
}
