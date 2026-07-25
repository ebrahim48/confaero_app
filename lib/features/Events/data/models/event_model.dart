class EventModel {
  final String id;
  final String title;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? bannerImageUrl;
  // Explore events extra fields
  final String? website;
  final int? expectedAttendee;
  final int? boothSlot;
  // Detail fields
  final String? googleMapLink;
  final String? eventType;
  final double? price;
  final String? details;
  final String? paymentType;
  final DateTime? createdAt;
  final String? registrationStatus;
  final double? latitude;
  final double? longitude;

  EventModel({
    required this.id,
    required this.title,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.bannerImageUrl,
    this.website,
    this.expectedAttendee,
    this.boothSlot,
    this.googleMapLink,
    this.eventType,
    this.price,
    this.details,
    this.paymentType,
    this.createdAt,
    this.registrationStatus,
    this.latitude,
    this.longitude,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      bannerImageUrl: json['bannerImageUrl'] as String?,
      website: json['website'] as String?,
      expectedAttendee: json['expectedAttendee'] as int?,
      boothSlot: json['boothSlot'] as int?,
      googleMapLink: json['googleMapLink'] as String?,
      eventType: json['eventType'] as String?,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      details: json['details'] as String?,
      paymentType: json['paymentType'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      registrationStatus: json['registrationStatus'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
    );
  }

  bool get hasCoordinates => latitude != null && longitude != null;

  /// Formats: "Jun 22-25, 2026" or "Jun 22 - Jul 5, 2026"
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

  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isUpcoming => startDate.isAfter(DateTime.now());

  bool get isRegistered =>
      registrationStatus == 'VERIFIED' || registrationStatus == 'PENDING';
}