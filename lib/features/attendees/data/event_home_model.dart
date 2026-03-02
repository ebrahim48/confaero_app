class EventHomeModel {
  final String title;
  final String banner;
  final String venue;
  final String details;
  final DateTime startDate;
  final DateTime endDate;

  EventHomeModel({
    required this.title,
    required this.banner,
    required this.venue,
    required this.details,
    required this.startDate,
    required this.endDate,
  });

  factory EventHomeModel.fromJson(Map<String, dynamic> json) {
    final info = json['eventInfo'] as Map<String, dynamic>? ?? json;
    return EventHomeModel(
      title: info['title'] as String? ?? '',
      banner: info['banner'] as String? ?? '',
      venue: info['venue'] as String? ?? '',
      details: info['details'] as String? ?? '',
      startDate: DateTime.parse(info['startDate'] as String),
      endDate: DateTime.parse(info['endDate'] as String),
    );
  }

  String get formattedDateRange {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final sm = months[startDate.month - 1];
    final em = months[endDate.month - 1];
    if (startDate.month == endDate.month && startDate.year == endDate.year) {
      return '$sm ${startDate.day}-${endDate.day}, ${startDate.year}';
    }
    return '$sm ${startDate.day} - $em ${endDate.day}, ${endDate.year}';
  }
}