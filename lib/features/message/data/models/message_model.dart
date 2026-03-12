class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String attachmentUrl;
  final bool isSeen;
  final DateTime createdAt;
  final bool isMe;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.attachmentUrl,
    required this.isSeen,
    required this.createdAt,
    this.isMe = false,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final sender = json['senderId']?.toString() ?? '';
    return MessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: sender,
      content: json['content']?.toString() ?? '',
      attachmentUrl: json['attachmentUrl']?.toString() ?? '',
      isSeen: json['isSeen'] as bool? ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString()) ??
                  DateTime.now()
              : DateTime.now(),
      isMe: currentUserId != null && sender == currentUserId,
    );
  }
}
