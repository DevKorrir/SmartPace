// Chat Message Model
class ChatMessage {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  final int unreadCount;
  final bool isOnline;

  ChatMessage({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  ChatMessage copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? time,
    String? avatarUrl,
    int? unreadCount,
    bool? isOnline,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      time: time ?? this.time,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      unreadCount: unreadCount ?? this.unreadCount,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

// Individual Message Model
class Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final String senderName;
  final MessageStatus status;

  Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.timestamp,
    this.senderName = '',
    this.status = MessageStatus.sent,
  });

  Message copyWith({
    String? id,
    String? text,
    bool? isMe,
    DateTime? timestamp,
    String? senderName,
    MessageStatus? status,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isMe: isMe ?? this.isMe,
      timestamp: timestamp ?? this.timestamp,
      senderName: senderName ?? this.senderName,
      status: status ?? this.status,
    );
  }
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}