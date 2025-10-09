import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState(chatId: '', isLoading: true)) {
    on<LoadConversation>(_onLoadConversation);
    on<SendMessage>(_onSendMessage);
  }

  Future<void> _onLoadConversation(LoadConversation event, Emitter<ChatState> emit) async {
    emit(ChatState(
      chatId: event.chatId,
      peerName: event.peerName,
      avatar: event.avatar,
      isLoading: true,
      messages: const [],
    ));
    await Future.delayed(const Duration(milliseconds: 250));
    emit(state.copyWith(
      isLoading: false,
      messages: const [
        ChatMessage(fromMe: false, text: 'Hi there! How can I help you?', time: '10:00'),
        ChatMessage(fromMe: true, text: 'I wanted to discuss details about the task.', time: '10:02'),
      ],
    ));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    final List<ChatMessage> updated = List.of(state.messages)
      ..add(ChatMessage(fromMe: true, text: event.text, time: _formatNow()));
    emit(state.copyWith(messages: updated));
  }

  String _formatNow() {
    final now = DateTime.now();
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(now.hour)}:${two(now.minute)}';
  }
}



