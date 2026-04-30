import 'package:flutter/material.dart';
import 'package:lingu/presentation/screens/chat/components/chat_layout/bottom_panel_controller.dart';

class BottomPanel extends StatefulWidget {
  final BottomPanelController? controller;
  final Widget child;
  final bool isVisible;

  const BottomPanel({
    super.key,
    this.controller,
    required this.child,
    this.isVisible = false,
  });

  @override
  State<BottomPanel> createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: widget.isVisible
          ? LayoutBuilder(
              key: const ValueKey('bottom_panel_content'),
              builder: (context, constraints) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: constraints.maxHeight * 0.55,
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
                                  duration: const Duration(milliseconds: 175),
                                  curve: Curves.easeOut,
                                  width: 40,
                                  height: 8,
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
                  ),
                );
              },
            )
          : const SizedBox.shrink(key: ValueKey('bottom_panel_empty')),
    );
  }
}
