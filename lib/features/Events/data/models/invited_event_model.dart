/// Represents a single invited event built by merging:
///   - invitation data from `GET /invitation/my-invitations`
///   - event details from `GET /attendee/events/{eventId}`
///
/// The [isregistration] field is derived from the invitation's [status]:
///   - `"PENDING"` | `"INVITED"` (String)  → invitation not yet answered → show Accept/Reject
///   - `"ACCEPTED"` (String)                → accepted → show Join Now
///   - absent / other                       → treated as pending
class InvitedEventModel {
  final String id;
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? bannerImageUrl;

  /// The invitation's status from the invitations API.
  /// Values: "PENDING", "INVITED", "ACCEPTED", "REJECTED"
  final String invitationStatus;

  /// The invitation ID — needed to call accept/reject endpoints.
  final String invitationId;

  /// The user's role for this invitation (e.g. "SPEAKER").
  final String role;

  InvitedEventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.bannerImageUrl,
    required this.invitationStatus,
    required this.invitationId,
    required this.role,
  });

  factory InvitedEventModel.fromJson(Map<String, dynamic> json) {
    return InvitedEventModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      bannerImageUrl: json['bannerImageUrl'] as String?,
      invitationStatus: (json['invitationStatus'] as String? ?? '').toUpperCase(),
      invitationId: json['invitationId'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );
  }

  /// True when the user has not yet responded to the invitation.
  ///
  /// Returns `true` for status: PENDING, INVITED, empty, or unrecognized.
  /// Returns `false` only when [invitationStatus] is `"ACCEPTED"`.
  bool get isPending {
    final s = invitationStatus.toUpperCase();
    return s == 'PENDING' || s == 'INVITED' || s.isEmpty;
  }

  /// True only when [invitationStatus] is `"ACCEPTED"`.
  bool get isAccepted => invitationStatus.toUpperCase() == 'ACCEPTED';

  /// True when the invitation has been rejected.
  bool get isRejected => invitationStatus.toUpperCase() == 'REJECTED';

  /// Formats the event date range.
  ///
  /// Same logic as [EventModel.formattedDateRange]:
  /// - Same month/year: `"Jun 22-25, 2026"`
  /// - Different months: `"Jun 22 - Jul 5, 2026"`
  String get formattedDateRange {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final sm = months[startDate.month - 1];
    final em = months[endDate.month - 1];
    if (startDate.month == endDate.month && startDate.year == endDate.year) {
      return '$sm ${startDate.day}-${endDate.day}, ${startDate.year}';
    }
    return '$sm ${startDate.day} - $em ${endDate.day}, ${endDate.year}';
  }
}
