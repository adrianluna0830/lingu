import 'package:flutter/material.dart';

class PageViewDirectionButtons extends StatelessWidget {
  final int totalPages;
  final int currentPage;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  const PageViewDirectionButtons({super.key, required this.totalPages, required this.currentPage, required this.onLeft, required this.onRight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onLeft,
        ),
        const Spacer(),
        Text('${currentPage + 1} / $totalPages'),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: onRight,
        ),
      ],
    );
  }
}
