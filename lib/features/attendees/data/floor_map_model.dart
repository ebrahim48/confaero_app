class FloorMapModel {
  final String id;
  final String title;
  final String imageUrl;
  final int order;

  FloorMapModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.order,
  });

  factory FloorMapModel.fromJson(Map<String, dynamic> json) {
    return FloorMapModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );
  }
}