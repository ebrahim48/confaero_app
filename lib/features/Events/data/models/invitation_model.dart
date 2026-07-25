import 'event_model.dart';

/// One item from `GET /invitation/my-invitations`.
///
/// Response structure:
/// {
///   "_id": "invitationId",
///   "eventId": { ...EventModel-ish (populated) or "id" string (unpopulated)... },
///   "organizerId": "...",
///   "email": "...",
///   "role": "VOLUNTEER" | "SPEAKER" | "SPONSOR" | ...,
///   "status": "PENDING" | "ACCEPTED" | "REJECTED" | "INVITED"
/// }
class InvitationModel {
  /// Invitation id — used with accept/reject endpoints.
  final String id;
  final String eventId;

  /// Populated event when the API returns an `eventId` object; otherwise null.
  final EventModel? event;
  final String role;
  final String status;

  InvitationModel({
    required this.id,
    required this.eventId,
    required this.role,
    required this.status,
    this.event,
  });

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    final rawEvent = json['eventId'];

    EventModel? event;
    String eventId = '';

    if (rawEvent is Map<String, dynamic>) {
      eventId = rawEvent['_id'] as String? ?? '';
      // The populated event object may omit some fields (price/details) —
      // EventModel.fromJson only requires id/title/location/dates.
      try {
        event = EventModel.fromJson(rawEvent);
      } catch (_) {
        event = null;
      }
    } else if (rawEvent is String) {
      eventId = rawEvent;
    }

    return InvitationModel(
      id: json['_id'] as String? ?? '',
      eventId: eventId,
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? '',
      event: event,
    );
  }

  String get statusUpper => status.toUpperCase();

  /// Unanswered invitation — the user still needs to accept or reject it.
  bool get isPending =>
      statusUpper == 'PENDING' ||
      statusUpper == 'INVITED' ||
      statusUpper.isEmpty;

  bool get isAccepted => statusUpper == 'ACCEPTED';
  bool get isRejected => statusUpper == 'REJECTED';
}
