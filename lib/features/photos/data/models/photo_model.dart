class PhotoModel {
  final String id;
  final String imageUrl;
  final String eventId;
  final String uploaderId;
  final String createdAt;

  PhotoModel({
    required this.id,
    required this.imageUrl,
    required this.eventId,
    required this.uploaderId,
    required this.createdAt,
  });

  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      id: json['_id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      uploaderId: json['uploaderId']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
