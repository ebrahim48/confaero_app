import 'event_model.dart';

/// Represents a unified event entry from the /attendee/my-events endpoint.
/// This API returns events where the user is either REGISTERED or INVITED.
/// 
/// Response structure:
/// {
///   "event": { ...EventModel... },
///   "status": "REGISTERED" | "INVITED",
///   "invitationRole": "SPEAKER" | null
/// }
class MyEventsAndInvitationsModel {
  final EventModel event;
  final String status;
  final String? invitationRole;

  MyEventsAndInvitationsModel({
    required this.event,
    required this.status,
    this.invitationRole,
  });

  factory MyEventsAndInvitationsModel.fromJson(Map<String, dynamic> json) {
    return MyEventsAndInvitationsModel(
      event: EventModel.fromJson(json['event'] as Map<String, dynamic>),
      status: json['status'] as String? ?? '',
      invitationRole: json['invitationRole'] as String?,
    );
  }

  bool get isRegistered => status == 'REGISTERED';
  bool get isInvited => status == 'INVITED';
  bool get isSpeaker => invitationRole == 'SPEAKER';
}
