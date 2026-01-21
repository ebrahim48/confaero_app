class QuickNoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  QuickNoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  factory QuickNoteModel.fromJson(Map<String, dynamic> json) {
    return QuickNoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }
}