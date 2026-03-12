class NoteModel {
  final String id;
  final String eventId;
  final String content;
  final String createdAt;
  final String updatedAt;

  NoteModel({
    required this.id,
    required this.eventId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['_id']?.toString() ?? '',
      eventId: json['eventId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      updatedAt: json['updatedAt']?.toString() ?? '',
    );
  }
}
