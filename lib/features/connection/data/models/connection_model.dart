class ConnectionModel {
  final String id;
  final String accountId;
  final String name;
  final String company;
  final String role;
  final int sessionsCount;
  final String avatarUrl;
  bool isBookmarked;
  // Detail fields (populated from GET /connection/:id)
  final String? email;
  final String? phone;
  final String? location;
  final bool canMessage;
  final bool canEmail;

  ConnectionModel({
    required this.id,
    required this.accountId,
    required this.name,
    required this.company,
    required this.role,
    required this.sessionsCount,
    required this.avatarUrl,
    this.isBookmarked = false,
    this.email,
    this.phone,
    this.location,
    this.canMessage = false,
    this.canEmail = false,
  });

  factory ConnectionModel.fromJson(Map<String, dynamic> json) {
    final contact = json['contact'] as Map<String, dynamic>?;
    final actions = json['actions'] as Map<String, dynamic>?;
    return ConnectionModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      accountId: json['accountId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      company: json['company']?.toString() ?? '',
      role: json['role']?.toString() ?? json['activeRole']?.toString() ?? 'ATTENDEE',
      sessionsCount: json['sessionsCount'] as int? ?? 0,
      avatarUrl: json['avatar']?.toString() ?? json['avatarUrl']?.toString() ?? '',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      email: contact?['email']?.toString(),
      phone: contact?['phone']?.toString(),
      location: contact?['location']?.toString(),
      canMessage: actions?['canMessage'] as bool? ?? false,
      canEmail: actions?['canEmail'] as bool? ?? false,
    );
  }
}
