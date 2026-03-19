import 'package:injectable/injectable.dart';
import 'package:lingu/features/chat/logic/panel/panel_type.dart';
import 'package:signals/signals_flutter.dart';

@singleton
class PanelManager {
  final _currentPanel = signal(PanelType.none);
  ReadonlySignal<PanelType> get currentPanel => _currentPanel;
  void openMicPanel() {
    _currentPanel.value = PanelType.mic;
  }

  void closePanel() {
    _currentPanel.value = PanelType.none;
  }

  void openChatPanel() {
    _currentPanel.value = PanelType.chat;
  }
}
