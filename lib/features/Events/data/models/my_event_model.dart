import 'event_model.dart';
import 'event_participation.dart';

/// One entry of `GET /attendee/my-events` — the unified list of events the user
/// is registered for *or* has been invited to.
///
/// ```json
/// { "event": { ... }, "status": "REGISTERED" }
/// { "event": { ... }, "status": "INVITED", "invitationRole": "SPEAKER" }
/// ```
class MyEventModel {
  final EventModel event;

  /// [MyEventStatus.registered] or [MyEventStatus.invited].
  final String status;

  /// Role carried by the invitation, e.g. `SPEAKER`. Empty for registrations.
  final String invitationRole;

  /// Invitation id, filled in by merging with `GET /invitation/my-invitations`
  /// — `my-events` does not return it. Needed for accept / reject.
  final String invitationId;

  /// Status of the merged invitation ([InvitationStatus]). Empty until merged.
  final String invitationStatus;

  const MyEventModel({
    required this.event,
    required this.status,
    this.invitationRole = '',
    this.invitationId = '',
    this.invitationStatus = '',
  });

  factory MyEventModel.fromJson(Map<String, dynamic> json) {
    return MyEventModel(
      event: EventModel.fromJson(json['event'] as Map<String, dynamic>),
      status: (json['status'] as String? ?? '').toUpperCase(),
      // `invitationRole` is the documented field; `role` / `activeRole` are
      // tolerated because older backend builds sent those instead.
      invitationRole: ((json['invitationRole'] ??
                  json['role'] ??
                  json['activeRole']) as String? ??
              '')
          .toUpperCase(),
    );
  }

  MyEventModel copyWith({
    String? invitationId,
    String? invitationRole,
    String? invitationStatus,
  }) {
    return MyEventModel(
      event: event,
      status: status,
      invitationRole: invitationRole ?? this.invitationRole,
      invitationId: invitationId ?? this.invitationId,
      invitationStatus: invitationStatus ?? this.invitationStatus,
    );
  }

  bool get isRegistered => status == MyEventStatus.registered;

  bool get isInvited => status == MyEventStatus.invited;

  /// An invitation the user has not answered yet — show Accept / Reject.
  bool get isPendingInvitation =>
      isInvited && invitationStatus != InvitationStatus.accepted;

  /// The user can enter the event: either a registration, or an invitation
  /// they already accepted.
  bool get canEnter =>
      isRegistered ||
      (isInvited && invitationStatus == InvitationStatus.accepted);

  /// Role to send to `PATCH /attendee/event/:id/join?role=`.
  String get joinRole =>
      invitationRole.isNotEmpty ? invitationRole : AppRole.attendee;
}
