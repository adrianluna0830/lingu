import 'package:lingu/features/chat/logic/feedback/models/message_details_view_dto.dart';

sealed class PanelState {}

class NonePanelState implements PanelState {}

class ChatPanelState implements PanelState {
  final String? initialQuestion;

  ChatPanelState({this.initialQuestion});
}

class MicPanelState implements PanelState {}

class MessageDetailsPanelState implements PanelState {
  final MessageDetailsViewDto data;

  MessageDetailsPanelState(this.data);
}
