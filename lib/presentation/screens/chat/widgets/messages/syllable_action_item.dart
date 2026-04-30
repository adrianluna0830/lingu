import 'package:flutter/material.dart';

class SyllableActionItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? color;

  const SyllableActionItem({super.key, required this.text, required this.isSelected, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Text(
        text,
        style: TextStyle(color: color ?? Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, fontSize: 16, decoration: TextDecoration.none),
      ),
    );

    if (onTap == null) {
      return container;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      hoverColor: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
      splashColor: color?.withOpacity(0.2) ?? Colors.blue.withOpacity(0.2),
      highlightColor: color?.withOpacity(0.1) ?? Colors.blue.withOpacity(0.1),
      child: container,
    );
  }
}
