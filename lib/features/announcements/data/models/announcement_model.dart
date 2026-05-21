class AnnouncementModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String createdAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.createdAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
