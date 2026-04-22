import 'package:flutter/material.dart';

class NewChatPromptPopup extends StatelessWidget {
  final String? question;
  final VoidCallback onConfirm;
  final VoidCallback onDeny;

  const NewChatPromptPopup({
    super.key,
    required this.question,
    required this.onConfirm,
    required this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New Chat?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
                decoration: TextDecoration.none,
              ),
            ),
            if (question?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                question!,
                style: const TextStyle(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: onDeny, child: const Text('No')),
                const SizedBox(width: 8),
                TextButton(onPressed: onConfirm, child: const Text('Yes')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
