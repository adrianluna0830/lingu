import 'package:flutter/material.dart';
import 'package:lingu/features/chat/input_bar/input_bar_controller.dart';
import 'package:signals/signals_flutter.dart' show FlutterReadonlySignalUtils;

class InputBar extends StatefulWidget {
  final InputBarController controller;
  const InputBar(this.controller, {super.key});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: 'Type a message',
            ),
            onChanged:(value) {
              widget.controller.updateText(value);
            },
          ),
        ),
        IconButton(
          onPressed:() {
            if(widget.controller.showTextIcon.watch(context)) {
              widget.controller.submitText(_textController.text);
              _textController.clear();
            } else {
              widget.controller.startRecording();
            }
          },
          icon: Icon(widget.controller.showTextIcon.watch(context) ? Icons.send : Icons.mic),
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
        ),
        IconButton(
          onPressed: widget.controller.chat,
          icon: const Icon(Icons.message),
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue.shade200,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
        )

      ],
    );
  }
}