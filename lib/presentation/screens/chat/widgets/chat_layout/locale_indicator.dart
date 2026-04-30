import 'package:flutter/material.dart';
import 'package:lingu/domain/core/models/language_locale.dart';

class LocaleIndicator extends StatelessWidget {
  final LanguageLocale locale;

  const LocaleIndicator({super.key, required this.locale});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1.5,
        ),
      ),
      child: Text(
        locale.display,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
