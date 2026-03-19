import 'package:signals/signals.dart';

class InputBarController
{
  Function(String)? onTextSubmit;
  Function()? onStartRecording;
  Function()? onChat;
  
  final _isFocusedSignal = signal(false);
  ReadonlySignal get isFocused => _isFocusedSignal;


  final _textSignal = signal("");
  String get text => _textSignal.value;

  late final showTextIcon = computed(() => text.isNotEmpty);

  void setFocused(bool focused) => _isFocusedSignal.value = focused;

  void updateText(String newText) => _textSignal.value = newText;
  
  void submitText(String text)
  {
    onTextSubmit?.call(text);
    _textSignal.value = "";
  }

  void startRecording() => onStartRecording?.call();

  void chat() => onChat?.call();
}
