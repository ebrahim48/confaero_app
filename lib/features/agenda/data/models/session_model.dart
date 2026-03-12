class SessionModel {
  final String id;
  final String title;
  final String description;
  final String startTime;
  final String endTime;
  final String location;
  final bool isBookmarked;
  final bool isLiked;
  final int likesCount;

  SessionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.isBookmarked = false,
    this.isLiked = false,
    this.likesCount = 0,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startTime: json['startTime']?.toString() ?? '',
      endTime: json['endTime']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      isLiked: json['isLiked'] as bool? ?? false,
      likesCount: json['likesCount'] as int? ?? 0,
    );
  }
}

class SpeakerModel {
  final String id;
  final String name;
  final String bio;
  final String avatarUrl;

  SpeakerModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatarUrl,
  });

  factory SpeakerModel.fromJson(Map<String, dynamic> json) {
    return SpeakerModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
    );
  }
}
