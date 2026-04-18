class AttendeeModel {
  final String id;
  final String accountId;
  final String name;
  final String company;
  final String role;
  final int eventsCount;
  final int sessionsCount;
  final String avatarUrl;
  final String? email;
  final String? phone;
  final String? location;
  bool isBookmarked;
  bool isOnline;

  AttendeeModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.company,
    required this.role,
    required this.eventsCount,
    required this.sessionsCount,
    required this.avatarUrl,
    this.email,
    this.phone,
    this.location,
    this.isBookmarked = false,
    this.isOnline = false,
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    final contact = json['contact'] as Map<String, dynamic>?;
    return AttendeeModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      role:
          json['activeRole']?.toString() ??
          json['role']?.toString() ??
          'Attendee',
      eventsCount: json['eventsCount'] as int? ?? 0,
      sessionsCount: json['sessionsCount'] as int? ?? 0,
      avatarUrl: json['avatar']?.toString() ?? json['avatarUrl']?.toString() ?? '',
      email: contact?['email']?.toString() ?? json['email']?.toString(),
      phone: contact?['phone']?.toString() ?? json['phone']?.toString(),
      location: contact?['location']?.toString() ?? json['location']?.toString(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isOnline: json['isOnline'] as bool? ?? false,
    );
  }
}
