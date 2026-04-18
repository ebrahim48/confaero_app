// Domain model for the conversation list UI item
class MessageModel {
  final String id; // conversationId
  final String participantId; // the other user's accountId
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  bool hasUnread;

  MessageModel({
    required this.id,
    required this.participantId,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.hasUnread = false,
  });
}
