import 'package:flutter/material.dart';

class BottomPanelController {
  VoidCallback? onClose;
  BottomPanelController({this.onClose});
}

class BottomPanel extends StatefulWidget {
  final BottomPanelController? controller;
  final Widget child;

  const BottomPanel({super.key, this.controller, required this.child});

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[300],
      child: Column(
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => widget.controller?.onClose?.call(),
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 8, // Un poco más alto
                    decoration: BoxDecoration(
                      color: _isHovering ? Colors.grey.shade600 : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}
