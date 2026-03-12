import 'message_model.dart';

class ConversationModel {
  final String id;
  final String eventId;
  final String participantName;
  final String participantAvatar;
  final String participantId;
  final MessageModel? lastMessage;
  final int unreadCount;

  ConversationModel({
    required this.id,
    required this.eventId,
    required this.participantName,
    required this.participantAvatar,
    required this.participantId,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    // Note: Parsing strategy depends on exact API structure, typically user's profile is nested.
    final participant = json['participant'] as Map<String, dynamic>? ?? {};

    return ConversationModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      participantName: participant['name']?.toString() ?? 'User',
      participantAvatar: participant['avatar']?.toString() ?? '',
      participantId: participant['_id']?.toString() ?? '',
      lastMessage:
          json['lastMessage'] != null
              ? MessageModel.fromJson(
                json['lastMessage'] as Map<String, dynamic>,
              )
              : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}
