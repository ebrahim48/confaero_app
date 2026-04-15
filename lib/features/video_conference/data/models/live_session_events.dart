/// Model for session ended event.
///
/// Received from socket event: `event-live:session-ended`
class SessionEndedEvent {
  final String endedBy;
  final DateTime endedAt;

  SessionEndedEvent({
    required this.endedBy,
    required this.endedAt,
  });

  factory SessionEndedEvent.fromJson(Map<String, dynamic> json) {
    return SessionEndedEvent(
      endedBy: json['endedBy']?.toString() ?? 'SPEAKER',
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endedBy': endedBy,
      'endedAt': endedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'SessionEndedEvent(endedBy: $endedBy, endedAt: $endedAt)';
}

/// Model for viewer count update.
///
/// Received from socket event: `event-live:viewer-count`
class ViewerCountUpdate {
  final int sessionIndex;
  final int count;

  ViewerCountUpdate({
    required this.sessionIndex,
    required this.count,
  });

  factory ViewerCountUpdate.fromJson(Map<String, dynamic> json) {
    return ViewerCountUpdate(
      sessionIndex: json['sessionIndex'] as int? ?? 0,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionIndex': sessionIndex,
      'count': count,
    };
  }

  @override
  String toString() => 'ViewerCountUpdate(sessionIndex: $sessionIndex, count: $count)';
}

/// Model for speaker control message (mute/unmute).
///
/// Received from socket events: `event-live:force-mute`, `event-live:allow-unmute`
class SpeakerControlMessage {
  final String message;

  SpeakerControlMessage({
    required this.message,
  });

  factory SpeakerControlMessage.fromJson(Map<String, dynamic> json) {
    return SpeakerControlMessage(
      message: json['message']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }

  @override
  String toString() => 'SpeakerControlMessage(message: $message)';
}
