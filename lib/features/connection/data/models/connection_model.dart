class ConnectionModel {
  final String id;
  final String name;
  final String company;
  final String role;
  final int eventsCount;
  final int sessionsCount;
  final String avatarUrl;
  bool isBookmarked;

  ConnectionModel({
    required this.id,
    required this.name,
    required this.company,
    required this.role,
    required this.eventsCount,
    required this.sessionsCount,
    required this.avatarUrl,
    this.isBookmarked = false,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    return ConnectionModel(
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
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }
}
