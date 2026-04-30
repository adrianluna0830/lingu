import 'package:lingu/domain/interfaces/ai/i_ai_service.dart';
import 'package:lingu/domain/interfaces/ai/ai_chat_history.dart';
import 'package:lingu/domain/chat/models/chat/chat_panel_message.dart';
import 'package:signals/signals_flutter.dart';

class ChatPanelManager {
  final IAIService _iaimodel;
  
  final _messages = listSignal<ChatPanelMessage>([]);
  ReadonlySignal<List<ChatPanelMessage>> get messages => _messages;
  
  AIChatHistory _history = const AIChatHistory();

  ChatPanelManager(this._iaimodel);

  Future<void> onNewUserMessage(String text) async {
    _messages.add(ChatPanelMessage(text: text, isUser: true));
    
    final result = await _iaimodel.generateChatContent(
      prompt: text,
      chatHistory: _history,
    );
    
    _history = _history.addUser(text);

    if (result.messages.isNotEmpty) {
      final lastMessage = result.messages.last;
      _messages.add(ChatPanelMessage(text: lastMessage.text, isUser: false));
      _history = _history.addModel(lastMessage.text);
    }
  }

  void onNewChat() {
    _messages.clear();
    _history = const AIChatHistory();
  }
}
