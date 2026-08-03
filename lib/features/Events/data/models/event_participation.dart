/// Single source of truth for the participation vocabulary the backend uses
/// across the events / invitations APIs. Keeping the raw strings in one place
/// stops the "VERIFIED vs REGISTERED vs ACCEPTED" drift that the screens used
/// to each guess at.
library;

/// `status` on each item of `GET /attendee/my-events`.
class MyEventStatus {
  MyEventStatus._();

  /// Attendee completed self-registration.
  static const String registered = 'REGISTERED';

  /// User was invited for a non-attendee role.
  static const String invited = 'INVITED';
}

/// `registrationStatus` on `GET /attendee/events/:eventId`.
class RegistrationStatus {
  RegistrationStatus._();

  static const String notRegistered = 'NOT_REGISTERED';

  /// Payment / email verification still outstanding.
  static const String pending = 'PENDING';

  /// Registration complete — the user may enter the event.
  static const String verified = 'VERIFIED';
}

/// `status` on each item of `GET /invitation/my-invitations`.
class InvitationStatus {
  InvitationStatus._();

  static const String pending = 'PENDING';
  static const String accepted = 'ACCEPTED';
  static const String rejected = 'REJECTED';
}

/// Roles a user can hold. Only [attendee] joins by self-registration; every
/// other role reaches an event through an invitation.
class AppRole {
  AppRole._();

  static const String attendee = 'ATTENDEE';
  static const String organizer = 'ORGANIZER';
  static const String speaker = 'SPEAKER';
  static const String exhibitor = 'EXHIBITOR';
  static const String staff = 'STAFF';
  static const String sponsor = 'SPONSOR';
  static const String volunteer = 'VOLUNTEER';
  static const String abstractReviewer = 'ABSTRACT_REVIEWER';
  static const String trackChair = 'TRACK_CHAIR';

  /// Roles an organizer may invite someone as.
  static const Set<String> invitable = {
    speaker,
    staff,
    exhibitor,
    volunteer,
    trackChair,
    sponsor,
    abstractReviewer,
  };

  /// True when [role] joins events by accepting an invitation rather than by
  /// calling `initiate-registration`.
  static bool isInviteOnly(String role) =>
      invitable.contains(role.trim().toUpperCase());

  /// True when [role] may self-register for an event.
  static bool canSelfRegister(String role) =>
      role.trim().toUpperCase() == attendee || role.trim().isEmpty;
}
