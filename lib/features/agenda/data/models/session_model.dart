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
    // Parse time field which can be in format "08:00 - 10:00" or "08:00-10:30"
    String startTime = '';
    String endTime = '';
    
    final timeStr = json['time']?.toString() ?? '';
    if (timeStr.isNotEmpty) {
      // Try to split by ' - ' first (with spaces)
      if (timeStr.contains(' - ')) {
        final parts = timeStr.split(' - ');
        startTime = parts[0];
        endTime = parts.length > 1 ? parts[1] : '';
      } 
      // Try to split by '-' (without spaces)
      else if (timeStr.contains('-')) {
        final parts = timeStr.split('-');
        startTime = parts[0].trim();
        endTime = parts.length > 1 ? parts[1].trim() : '';
      } 
      // If no separator found, use the whole string as startTime
      else {
        startTime = timeStr;
      }
    }
    
    return SessionModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      startTime: startTime,
      endTime: endTime,
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
