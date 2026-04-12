import 'package:lingu/features/chat/logic/feedback/models/message_details_data.dart';

sealed class PanelState {}

class NonePanelState implements PanelState {}

class ChatPanelState implements PanelState {}

class MicPanelState implements PanelState {}

class MessageDetailsPanelState implements PanelState {
  final MessageDetailsData data;

  MessageDetailsPanelState(this.data);
}
