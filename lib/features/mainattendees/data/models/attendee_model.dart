class AttendeeModel {
  final String id;
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

  AttendeeModel({
    required this.id,
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
  });

  factory AttendeeModel.fromJson(Map<String, dynamic> json) {
    return AttendeeModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      role:
          json['activeRole']?.toString() ??
          json['role']?.toString() ??
          'Attendee',
      eventsCount: json['eventsCount'] as int? ?? 0,
      sessionsCount: json['sessionsCount'] as int? ?? 0,
      avatarUrl:
          json['avatar']?.toString() ?? json['avatarUrl']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      location: json['location']?.toString(),
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }
}
