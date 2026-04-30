import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingu/domain/core/models/language_locale.dart';
import 'package:lingu/presentation/ui_utils.dart';
import 'package:lingu/presentation/screens/chat/components/input/input_bar_controller.dart';
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
  final LanguageLocale nativeLocale;
  final LanguageLocale targetLocale;

  const InputBar(
    this.controller, {
    super.key,
    required this.nativeLocale,
    required this.targetLocale,
  });

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

    return Focus(
      descendantsAreFocusable: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.tab) {
          _internalController.toggleTypingLanguage();
          return KeyEventResult.handled; // Evita que el Tab salte al AppBar
        }
        return KeyEventResult.ignored;
      },
      child: Row(
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
              onSubmitted: (value) {
                if (_internalController.showTextIcon.value) {
                  _internalController.submitText();
                  _textController.clear();
                  _focusNode.requestFocus();
                }
              },
            ),
          ),
          if (_internalController.showTextIcon.watch(context)) ...[
            const SizedBox(width: 8.0),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ExcludeFocus(
                child: ToggleButtons(
                  isSelected: [!isTargetLang, isTargetLang],
                  onPressed: (index) {
                    if ((index == 0 && isTargetLang) ||
                        (index == 1 && !isTargetLang)) {
                      _internalController.toggleTypingLanguage();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  selectedColor: Colors.white,
                  fillColor: isTargetLang
                      ? getLanguageColor(widget.targetLocale)
                      : getLanguageColor(widget.nativeLocale),
                  color: Colors.blue.shade700,
                  constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
                  renderBorder: false,
                  children: [
                    Text(getLanguageDisplayName(widget.nativeLocale, context),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                    Text(getLanguageDisplayName(widget.targetLocale, context),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(width: 8.0),
          ExcludeFocus(
            child: IconButton(
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          ExcludeFocus(
            child: IconButton(
              onPressed: _internalController.chat,
              icon: const Icon(Icons.message),
              style: IconButton.styleFrom(
                backgroundColor: Colors.blue.shade200,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
    );
  }
}