import 'package:lingu/domain/core/models/cefr.dart';

class ChatCEFR {
  final CEFR level;

  ChatCEFR(this.level);
  
  String get name => level.name.toUpperCase();
}
