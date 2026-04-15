class SponsorModel {
  final String id;
  final String name;
  final String logoUrl;
  final String websiteUrl;
  final String publicEmail;
  final String description;
  final int profileView;
  final String status;
  final bool isApproved;

  SponsorModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.websiteUrl,
    required this.publicEmail,
    required this.description,
    required this.profileView,
    required this.status,
    required this.isApproved,
  });

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
      id: json['_id']?.toString() ?? '',
      name: json['companyName']?.toString() ?? '',
      logoUrl: json['logoUrl']?.toString() ?? '',
      websiteUrl: json['websiteUrl']?.toString() ?? '',
      publicEmail: json['publicEmail']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      profileView: json['profileView'] as int? ?? 0,
      status: json['status']?.toString() ?? '',
      isApproved: json['isApproved'] as bool? ?? false,
    );
  }
}
