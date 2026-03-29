import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/bottom_panel/bottom_panel_controller.dart';

class BottomPanel extends StatelessWidget {
  final Widget child;
  final BottomPanelController? controller;

  const BottomPanel({super.key, this.controller, required this.child});



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(children: [
        IconButton(onPressed: () {
          controller?.onClose?.call();
        }, icon: const Icon(Icons.close)),
        child,
      ]),
    );
  }
}
