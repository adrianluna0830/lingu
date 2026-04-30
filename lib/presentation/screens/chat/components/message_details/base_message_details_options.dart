import 'package:flutter/material.dart';

class Option<T extends Enum> {
  final T value;
  final bool isEnabled;
  final VoidCallback? onPressed;

  const Option({
    required this.value,
    this.isEnabled = true,
    this.onPressed,
  });
}

class BaseMessageDetailsOptions<T extends Enum> extends StatefulWidget {
  final List<Option<T>> options;
  final String Function(T value, BuildContext context) labelBuilder;

  const BaseMessageDetailsOptions({
    super.key,
    required this.options,
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
    final enabledOptions = widget.options.where((e) => e.isEnabled && e.onPressed != null).toList();
    if (enabledOptions.length == 1) {
      selected = enabledOptions.first.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        enabledOptions.first.onPressed?.call();
      });
    }
  }

  bool _isDisabled(T value) {
    return !widget.options.firstWhere((e) => e.value == value).isEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ToggleButtons(
        isSelected: widget.options.map((e) => e.value == selected).toList(),
        onPressed: (index) {
          final option = widget.options[index];
          if (!option.isEnabled || option.onPressed == null) return;

          setState(() {
            selected = option.value;
          });
          option.onPressed?.call();
        },
        borderRadius: BorderRadius.circular(20),
        selectedColor: Colors.white,
        fillColor: Colors.blue.shade400,
        color: Colors.blue.shade700,
        disabledColor: Colors.blueGrey.shade200,
        constraints: const BoxConstraints(minHeight: 40, minWidth: 100),
        renderBorder: false,
        children: widget.options.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.labelBuilder(e.value, context),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          );
        }).toList(),
      ),
    );
  }
}