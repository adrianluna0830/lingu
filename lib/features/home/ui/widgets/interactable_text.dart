import 'package:flutter/material.dart';
import 'package:lingu/features/home/ui/widgets/toolbar_menu.dart';
import 'package:super_tooltip/super_tooltip.dart';

class InteractableText extends StatefulWidget {
  final String text;
  final VoidCallback onChat;
  final VoidCallback onWordInfo;
  final TextStyle? textStyle;

  const InteractableText({
    super.key,
    required this.text,
    required this.onChat,
    required this.onWordInfo,
    this.textStyle,
  });

  @override
  State<InteractableText> createState() => _InteractableTextState();
}

class _InteractableTextState extends State<InteractableText> {
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
        onTap: () => _controller.showTooltip(),
        child: Text(widget.text, style: widget.textStyle),
      ),
    );
  }
}
