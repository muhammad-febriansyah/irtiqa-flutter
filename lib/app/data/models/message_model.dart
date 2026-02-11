class MessageModel {
  final int id;
  final MessageSender sender;
  final MessageSender? recipient;
  final String content;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MessageModel({
    required this.id,
    required this.sender,
    this.recipient,
    required this.content,
    required this.isRead,
    this.readAt,
    required this.createdAt,
    this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? 0,
      sender: MessageSender.fromJson(json['sender'] ?? {}),
      recipient: json['recipient'] != null
          ? MessageSender.fromJson(json['recipient'])
          : null,
      content: json['content'] ?? '',
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'recipient': recipient?.toJson(),
      'content': content,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool isMine(int currentUserId) {
    return sender.id == currentUserId;
  }

  String getTimeString() {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
}

class MessageSender {
  final int id;
  final String name;
  final String? email;
  final String? role;
  final String? avatar;

  MessageSender({
    required this.id,
    required this.name,
    this.email,
    this.role,
    this.avatar,
  });

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      email: json['email'],
      role: json['role'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
    };
  }

  bool get isConsultant => role == 'consultant';
  bool get isUser => role == 'user';
}
