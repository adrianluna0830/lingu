import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lingu/core/word/word.dart';
import 'package:signals_flutter/signals_flutter.dart';

class EnglishWordView extends StatefulWidget {
  final EnglishWord word;
  const EnglishWordView({super.key, required this.word});

  @override
  State<EnglishWordView> createState() => _EnglishWordViewState();
}

class _EnglishWordViewState extends State<EnglishWordView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}