class Conversation {
  Conversation({required this.id, required this.peerName, this.avatar, this.lastMessage, this.unreadCount = 0});

  final String id;
  final String peerName;
  final String? avatar;
  final String? lastMessage;
  final int unreadCount;
}

class Message {
  Message({required this.id, required this.conversationId, required this.text, required this.fromMe, required this.sentAt});

  final String id;
  final String conversationId;
  final String text;
  final bool fromMe;
  final DateTime sentAt;
}



