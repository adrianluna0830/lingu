import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lingu/domain/word/models/word.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ImageAndCredits extends StatefulWidget {
  final WordImage image;
  final double? width;
  final double? height;
  const ImageAndCredits({
    super.key,
    required this.image,
    this.width,
    this.height,
  });

  @override
  State<ImageAndCredits> createState() => _ImageAndCreditsState();
}

class _ImageAndCreditsState extends State<ImageAndCredits> {
  final _showCredits = signal(false);

  @override
  Widget build(BuildContext context) {
    final showCredits = _showCredits.watch(context);
    return GestureDetector(
      onTap: () => _showCredits.value = !showCredits,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: widget.image.width / widget.image.height,
            child: Image.file(
              File(widget.image.imagePath),
              width: widget.width,
              height: widget.height,
              fit: BoxFit.cover,
            ),
          ),
          if (showCredits)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                widget.image.imageCredits,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}
