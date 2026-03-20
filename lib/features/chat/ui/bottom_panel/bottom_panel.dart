import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel_controller.dart';

class BottomPanel extends StatelessWidget {
  final BottomPanelController controller;

  const BottomPanel({super.key, required this.controller});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(children: [
        IconButton(onPressed: () {
          controller.onClose?.call();
        }, icon: const Icon(Icons.close)),
        const Text('Bottom Panel'),
        const SizedBox(height: 20),
      ]),
    );
  }
}
