import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  const ChatState({
    required this.chatId,
    this.peerName,
    this.avatar,
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  final String chatId;
  final String? peerName;
  final String? avatar;
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  ChatState copyWith({
    String? chatId,
    String? peerName,
    String? avatar,
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      chatId: chatId ?? this.chatId,
      peerName: peerName ?? this.peerName,
      avatar: avatar ?? this.avatar,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [chatId, peerName, avatar, messages, isLoading, error];
}

class ChatMessage extends Equatable {
  const ChatMessage({required this.fromMe, required this.text, required this.time});

  final bool fromMe;
  final String text;
  final String time;

  @override
  List<Object?> get props => [fromMe, text, time];
}



