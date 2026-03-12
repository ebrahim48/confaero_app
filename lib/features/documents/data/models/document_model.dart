class DocumentModel {
  final String id;
  final String name;
  final String fileUrl;
  final String eventId;
  final String authorId;
  final String createdAt;

  DocumentModel({
    required this.id,
    required this.name,
    required this.fileUrl,
    required this.eventId,
    required this.authorId,
    required this.createdAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      fileUrl: json['fileUrl']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}
