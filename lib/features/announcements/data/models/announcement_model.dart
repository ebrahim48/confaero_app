class AnnouncementModel {
  final String id;
  final String title;
  final String content;
  final String createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
