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
      color: Colors.black54,
      alignment: Alignment.center,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.chat_bubble_outline, size: 48, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                (question != null && question!.isNotEmpty)
                    ? 'Do you want to start a new chat with the following question?'
                    : 'Are you sure you want to start a new chat?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              if (question != null && question!.isNotEmpty)
                Text(
                  '"$question"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: onDeny,
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: onConfirm,
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
