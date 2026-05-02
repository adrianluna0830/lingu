import 'package:flutter/material.dart';
import 'package:lingu/presentation/widgets/toolbar_menu.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InteractiveSelectableText extends StatefulWidget {
  final String text;
  final VoidCallback onWordInfo;
  final VoidCallback onChat;
  final VoidCallback? onTap;
  final TextStyle? style;

  const InteractiveSelectableText({
    super.key,
    required this.text,
    required this.onWordInfo,
    required this.onChat,
    this.onTap,
    this.style,
  });

  @override
  State<InteractiveSelectableText> createState() => _InteractiveSelectableTextState();
}

class _InteractiveSelectableTextState extends State<InteractiveSelectableText> {
  final _controller = SuperTooltipController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SuperTooltip(
      controller: _controller,
      style: const TooltipStyle(
        backgroundColor: Color(0xFF2C2C2E),
        borderColor: Colors.transparent,
        borderWidth: 0,
        hasShadow: false,
      ),
      barrierConfig: const BarrierConfiguration(
        show: true,
        color: Colors.transparent,
      ),
      positionConfig: const PositionConfiguration(
        preferredDirection: TooltipDirection.up,
      ),
      arrowConfig: const ArrowConfiguration(
        length: 5.25,
        baseWidth: 18,
        tipRadius: 3.8,
        tipDistance: 13,
      ),
      interactionConfig: const InteractionConfiguration(
        toggleOnTap: false,
        hideOnTap: false,
        hideOnBarrierTap: true,
      ),
      content: ToolbarMenu(
        onChat: () {
          _controller.hideTooltip();
          widget.onChat();
        },
        onWordInfo: () {
          _controller.hideTooltip();
          widget.onWordInfo();
        },
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        hoverColor: Colors.black.withOpacity(0.04),
        splashColor: Colors.black.withOpacity(0.06),
        highlightColor: Colors.transparent,
        onTap: widget.onTap,
        onLongPress: () => _controller.showTooltip(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          child: Text(
            widget.text,
            style: widget.style,
          ),
        ),
      ),
    );
  }
}
