import 'package:lingu/domain/core/models/language_locale.dart';

class ChatLanguages {
  final LanguageLocale native;
  final LanguageLocale target;

  const ChatLanguages({required this.native, required this.target});
}
