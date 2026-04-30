import 'package:lingu/domain/chat/models/chat/message_details_view_dto.dart';

sealed class PanelState {}

class NonePanelState implements PanelState {}

class ChatPanelState implements PanelState {
  final String? initialMessage;

  ChatPanelState({this.initialMessage});
}

class MicPanelState implements PanelState {}

class MessageDetailsPanelState implements PanelState {
  final MessageDetails data;

  MessageDetailsPanelState(this.data);
}
