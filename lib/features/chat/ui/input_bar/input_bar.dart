import 'package:flutter/material.dart';
import 'package:lingu/features/chat/ui/input_bar/input_bar_controller.dart';
import 'package:signals/signals_flutter.dart' show FlutterReadonlySignalUtils;

class _RichTextEditingController extends TextEditingController {
  final List<(String, bool)> Function() getChars;

  _RichTextEditingController(this.getChars);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final chars = getChars();

    if (chars.length != text.length) {
      return TextSpan(text: text, style: style);
    }

    final List<TextSpan> spans = [];
    StringBuffer currentText = StringBuffer();
    bool? currentIsTarget;

    void addSpan() {
      if (currentText.isEmpty) return;
      spans.add(TextSpan(
        text: currentText.toString(),
        style: currentIsTarget == true
            ? style
            : style?.copyWith(fontWeight: FontWeight.bold),
      ));
      currentText.clear();
    }

    for (int i = 0; i < text.length; i++) {
      final isTarget = chars[i].$2;
      if (currentIsTarget != isTarget) {
        addSpan();
        currentIsTarget = isTarget;
      }
      currentText.write(text[i]);
    }
    addSpan();

    return TextSpan(children: spans, style: style);
  }
}

class InputBar extends StatefulWidget {
  final InputBarController? controller;
  const InputBar(this.controller, {super.key});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  late final InputBarInternalController _internalController =
      InputBarInternalController(controller: widget.controller);
  late final TextEditingController _textController =
      _RichTextEditingController(() => _internalController.textChars.value);
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      _internalController.setFocused(_focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTargetLang =
        _internalController.isTypingInTargetLanguage.watch(context);

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            focusNode: _focusNode,
            decoration: const InputDecoration(
              hintText: 'Type a message',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(width: 1.5, color: Colors.blueGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(width: 1.5, color: Colors.blue),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(width: 1.5),
              ),
            ),
            onChanged: (value) {
              _internalController.updateText(value);
            },
          ),
        ),
        const SizedBox(width: 8.0),
        if (_internalController.showTextIcon.watch(context)) ...[
          IconButton(
            onPressed: () {
              _internalController.toggleTypingLanguage();
            },
            icon: Icon(isTargetLang ? Icons.toggle_on : Icons.toggle_off),
            style: IconButton.styleFrom(
              backgroundColor: Colors.blue.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
        IconButton(
          onPressed: () {
            if (_internalController.showTextIcon.watch(context)) {
              _internalController.submitText();
              _textController.clear();
            } else {
              _internalController.startRecording();
            }
          },
          icon: Icon(_internalController.showTextIcon.watch(context)
              ? Icons.send
              : Icons.mic),
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue.shade200,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
        ),
        const SizedBox(width: 8.0),
        IconButton(
          onPressed: _internalController.chat,
          icon: const Icon(Icons.message),
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue.shade200,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
        ),
      ],
    );
  }
}