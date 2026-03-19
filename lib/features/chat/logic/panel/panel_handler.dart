import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/message/audio_message_input.dart';
import 'package:lingu/features/chat/chat_view.dart';
import 'package:lingu/features/chat/logic/panel/panel_manager.dart';
import 'package:lingu/features/text_message_input.dart';

@singleton 
class PanelHandler {
  final PanelManager _panelManager;
  final AudioMessageInput _audioMessageInput;
  final TextMessageInput _textMessageInput;
  PanelHandler(this._panelManager, this._audioMessageInput, this._textMessageInput) {
    _audioMessageInput.notifyCancelRecording = () {
      _panelManager.closePanel();
    };

    _audioMessageInput.notifyStopRecording = () {
      _panelManager.closePanel();
    };

    _textMessageInput.onGainFocus = () {
      _panelManager.closePanel();
    };
  }

  
}
