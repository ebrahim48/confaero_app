class MessageModel {
  final String id;
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  bool hasUnread;

  MessageModel({
    required this.id,
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.hasUnread = false,
  });
}
