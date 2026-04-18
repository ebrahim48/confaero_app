class ConversationModel {
  final String id;
  final String eventId;
  final String lastMessageText;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final List<String> participants;
  final String participantsKey;
  // Resolved externally once we know the current user's ID
  String participantId;
  String participantName;
  String participantAvatar;

  ConversationModel({
    required this.id,
    required this.eventId,
    required this.lastMessageText,
    this.lastMessageAt,
    required this.unreadCount,
    required this.participants,
    required this.participantsKey,
    this.participantId = '',
    this.participantName = 'User',
    this.participantAvatar = '',
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final rawParticipants = json['participants'] as List? ?? [];
    return ConversationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      lastMessageText: json['lastMessage']?.toString() ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.tryParse(json['lastMessageAt'].toString())
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      participants: rawParticipants.map((e) => e.toString()).toList(),
      participantsKey: json['participantsKey']?.toString() ?? '',
    );
  }
}
