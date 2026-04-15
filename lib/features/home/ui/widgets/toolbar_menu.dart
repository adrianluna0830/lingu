import 'package:flutter/material.dart';

class ToolbarMenu extends StatelessWidget {
  final VoidCallback onChat;
  final VoidCallback onWordInfo;

  const ToolbarMenu({
    super.key,
    required this.onChat,
    required this.onWordInfo,
  });

  Widget _toolbarButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        hoverColor: Colors.white12,
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toolbarButton(
            icon: Icons.chat_bubble_outline,
            label: 'Chat',
            onTap: onChat,
          ),
          const VerticalDivider(color: Color(0xFF555555)),
          _toolbarButton(
            icon: Icons.info_outline,
            label: 'Info',
            onTap: onWordInfo,
          ),
        ],
      ),
    );
  }
}
