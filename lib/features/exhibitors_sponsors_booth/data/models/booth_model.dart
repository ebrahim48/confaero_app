class BoothResourceModel {
  final String id;
  final String name;
  final String url;
  final String type;

  BoothResourceModel({
    required this.id,
    required this.name,
    required this.url,
    required this.type,
  });

  factory BoothResourceModel.fromJson(Map<String, dynamic> json) {
    return BoothResourceModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}

class BoothModel {
  final String id;
  final String companyName;
  final String banner;
  final String offerTitle;
  final String boothOpening;
  final String description;
  final String boothNumber;
  final String websiteUrl;
  final String publicEmail;
  final List<BoothResourceModel> resources;
  final String status;
  final bool isAccepted;

  BoothModel({
    required this.id,
    required this.companyName,
    required this.banner,
    required this.offerTitle,
    required this.boothOpening,
    required this.description,
    required this.boothNumber,
    required this.websiteUrl,
    required this.publicEmail,
    required this.resources,
    required this.status,
    required this.isAccepted,
  });

  factory BoothModel.fromJson(Map<String, dynamic> json) {
    final resourcesList = (json['resources'] as List? ?? [])
        .map((r) => BoothResourceModel.fromJson(r as Map<String, dynamic>))
        .toList();

    return BoothModel(
      id: json['_id']?.toString() ?? '',
      companyName: json['companyName']?.toString() ?? '',
      banner: json['banner']?.toString() ?? '',
      offerTitle: json['offerTitle']?.toString() ?? '',
      boothOpening: json['boothOpening']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      boothNumber: json['boothNumber']?.toString() ?? '',
      websiteUrl: json['websiteUrl']?.toString() ?? '',
      publicEmail: json['publicEmail']?.toString() ?? '',
      resources: resourcesList,
      status: json['status']?.toString() ?? '',
      isAccepted: json['isAccepted'] as bool? ?? false,
    );
  }
}
