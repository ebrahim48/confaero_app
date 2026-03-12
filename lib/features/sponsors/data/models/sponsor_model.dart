class SponsorModel {
  final String id;
  final String name;
  final String logoUrl;
  final String website;
  final String description;
  final int views;

  SponsorModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.website,
    required this.description,
    required this.views,
  });

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logoUrl: json['logoUrl']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      views: json['views'] as int? ?? 0,
    );
  }
}
