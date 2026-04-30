import 'package:lingu/domain/chat/models/chat/chat_message.dart';
import 'package:signals/signals.dart';

class InputBarController {
  Function(String)? onTextSubmit;
  Function()? onStartRecording;
  Function()? onChat;
  Function(bool)? onFocusChange;
  Function(String text,  List<UserTextInput> individualTextInputs)? onUserTextMessage;
}

class InputBarInternalController {
  final InputBarController? controller;

  InputBarInternalController({this.controller});

  final _isFocusedSignal = signal(false);
  ReadonlySignal<bool> get isFocused => _isFocusedSignal;

  final _isTypingInTargetLanguage = signal(true);
  ReadonlySignal<bool> get isTypingInTargetLanguage => _isTypingInTargetLanguage;

  final _textCharsSignal = signal<List<(String, bool)>>([]);
  ReadonlySignal<List<(String, bool)>> get textChars => _textCharsSignal;

  final _textSignal = signal("");
  String get text => _textSignal.value;

  late final showTextIcon = computed(() => text.isNotEmpty);

  void setFocused(bool focused) {
    _isFocusedSignal.value = focused;
    controller?.onFocusChange?.call(focused);
  }

  void updateText(String newText) {
    final currentChars = _textCharsSignal.value;
    final oldText = currentChars.map((e) => e.$1).join('');
    
    if (oldText == newText) return;

    int prefixLen = 0;
    while (prefixLen < oldText.length && prefixLen < newText.length && oldText[prefixLen] == newText[prefixLen]) {
      prefixLen++;
    }

    int suffixLen = 0;
    while (suffixLen < oldText.length - prefixLen && 
           suffixLen < newText.length - prefixLen && 
           oldText[oldText.length - 1 - suffixLen] == newText[newText.length - 1 - suffixLen]) {
      suffixLen++;
    }

    final newInserted = newText.substring(prefixLen, newText.length - suffixLen);
    
    final newChars = List<(String, bool)>.from(currentChars);
    newChars.removeRange(prefixLen, currentChars.length - suffixLen);
    
    final isTarget = _isTypingInTargetLanguage.value;
    final toInsert = newInserted.split('').map((char) => (char, isTarget)).toList();
    newChars.insertAll(prefixLen, toInsert);

    _textCharsSignal.value = newChars;
    _textSignal.value = newText;
  }
  
  void submitText() {
    final chars = _textCharsSignal.value;
    if (chars.isEmpty) return;

    final List<UserTextInput> inputs = [];
    StringBuffer currentString = StringBuffer();
    bool currentLang = chars.first.$2;

    for (final char in chars) {
      if (char.$2 == currentLang) {
        currentString.write(char.$1);
      } else {
        inputs.add(UserTextInput(currentString.toString(), currentLang));
        currentString = StringBuffer();
        currentString.write(char.$1);
        currentLang = char.$2;
      }
    }
    if (currentString.isNotEmpty) {
      inputs.add(UserTextInput(currentString.toString(), currentLang));
    }

    final fullText = chars.map((e) => e.$1).join('');
    
    controller?.onTextSubmit?.call(fullText);
    controller?.onUserTextMessage?.call(fullText, inputs);
    
    _textCharsSignal.value = [];
    _textSignal.value = "";
  }

  void toggleTypingLanguage() {
    _isTypingInTargetLanguage.value = !_isTypingInTargetLanguage.value;
  }

  void startRecording() => controller?.onStartRecording?.call();

  void chat() => controller?.onChat?.call();
}
