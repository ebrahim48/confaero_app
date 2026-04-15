/// Model for a live session chat message.
///
/// Received from socket event: `event-live:message-new`
class LiveSessionMessage {
  final String userId;
  final String text;
  final DateTime time;

  LiveSessionMessage({
    required this.userId,
    required this.text,
    required this.time,
  });

  factory LiveSessionMessage.fromJson(Map<String, dynamic> json) {
    return LiveSessionMessage(
      userId: json['userId']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
      time: json['time'] != null
          ? DateTime.parse(json['time'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'text': text,
      'time': time.toIso8601String(),
    };
  }

  @override
  String toString() => 'LiveSessionMessage(userId: $userId, text: $text, time: $time)';
}
