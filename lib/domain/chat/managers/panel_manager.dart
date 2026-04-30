import 'package:lingu/domain/chat/managers/message_details_manager.dart';
import 'package:lingu/domain/chat/models/enums/panel_state.dart';
import 'package:signals/signals_flutter.dart';

class PanelManager {
  final MessageDetailsManager _messageDetailsManager;

  final _currentPanel = signal<PanelState>(NonePanelState());
  ReadonlySignal<PanelState> get currentPanel => _currentPanel;

  PanelManager(this._messageDetailsManager);

  void selectMessage(int messageId) {
    final details = _messageDetailsManager.messageDetails.value[messageId];
    if (details != null) {
      _currentPanel.value = MessageDetailsPanelState(details);
    }
  }

  void openMicPanel() {
    _currentPanel.value = MicPanelState();
  }

  void closePanel() {
    _currentPanel.value = NonePanelState();
  }

  void openChatPanel({String? initialMessage}) {
    _currentPanel.value = ChatPanelState(initialMessage: initialMessage);
  }
}
