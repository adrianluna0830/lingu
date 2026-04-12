import 'package:flutter/material.dart';

class BaseMessageDetailsOptions<T extends Enum> extends StatefulWidget {
  final List<(T, VoidCallback?)> segments;
  final String Function(T value, BuildContext context) labelBuilder;

  const BaseMessageDetailsOptions({
    super.key,
    required this.segments,
    required this.labelBuilder,
  });

  @override
  State<BaseMessageDetailsOptions<T>> createState() =>
      _BaseMessageDetailsOptionsState<T>();
}

class _BaseMessageDetailsOptionsState<T extends Enum>
    extends State<BaseMessageDetailsOptions<T>> {
  T? selected;

  @override
  void initState() {
    super.initState();
    final enabledSegments = widget.segments.where((e) => e.$2 != null).toList();
    if (enabledSegments.length == 1) {
      selected = enabledSegments.first.$1;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        enabledSegments.first.$2?.call();
      });
    }
  }

  bool _isDisabled(T value) {
    return widget.segments.firstWhere((e) => e.$1 == value).$2 == null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ToggleButtons(
        isSelected: widget.segments.map((e) => e.$1 == selected).toList(),
        onPressed: (index) {
          final option = widget.segments[index];
          if (option.$2 == null) return;

          setState(() {
            selected = option.$1;
          });
          option.$2?.call();
        },
        borderRadius: BorderRadius.circular(20),
        selectedColor: Colors.white,
        fillColor: Colors.blue.shade400,
        color: Colors.blue.shade700,
        disabledColor: Colors.blueGrey.shade200,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
        renderBorder: false,
        children: widget.segments.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.labelBuilder(e.$1, context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          );
        }).toList(),
      ),
    );
  }
}