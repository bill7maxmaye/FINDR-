import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadConversation extends ChatEvent {
  const LoadConversation(this.chatId, {this.peerName, this.avatar});

  final String chatId;
  final String? peerName;
  final String? avatar;

  @override
  List<Object?> get props => [chatId, peerName, avatar];
}

class SendMessage extends ChatEvent {
  const SendMessage(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}



