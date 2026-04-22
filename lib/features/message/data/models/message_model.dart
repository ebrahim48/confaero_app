class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String text;
  final List<Map<String, dynamic>> attachments;
  final bool isSeen;
  final DateTime createdAt;
  final bool isMe;

  MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.text,
    this.attachments = const [],
    required this.isSeen,
    required this.createdAt,
    this.isMe = false,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final sender = json['senderId']?.toString() ?? '';
    final rawAttachments = json['attachments'] as List? ?? [];
    return MessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      conversationId: json['conversationId']?.toString() ?? '',
      senderId: sender,
      text: json['text']?.toString() ?? json['content']?.toString() ?? '',
      attachments: rawAttachments
          .whereType<Map>()
          .map((a) => Map<String, dynamic>.from(a))
          .toList(),
      isSeen: (json['readBy'] as List?)?.isNotEmpty ??
          json['isSeen'] as bool? ??
          false,
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()).toLocal()
          : DateTime.now(),
      isMe: currentUserId != null && sender == currentUserId,
    );
  }
}
