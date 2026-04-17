class AffiliationModel {
  final String company;
  final String position;
  final String from;
  final String to;
  final bool isCurrent;

  AffiliationModel({
    this.company = '',
    this.position = '',
    this.from = '',
    this.to = '',
    this.isCurrent = false,
  });

  factory AffiliationModel.fromJson(Map<String, dynamic> json) =>
      AffiliationModel(
        company: json['company']?.toString() ?? '',
        position: json['position']?.toString() ?? '',
        from: json['from']?.toString() ?? '',
        to: json['to']?.toString() ?? '',
        isCurrent: json['isCurrent'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'company': company,
        'position': position,
        'from': from,
        'to': to,
        'isCurrent': isCurrent,
      };
}

class EducationModel {
  final String institute;
  final String degree;
  final String major;
  final String from;
  final String to;
  final bool isCurrent;

  EducationModel({
    this.institute = '',
    this.degree = '',
    this.major = '',
    this.from = '',
    this.to = '',
    this.isCurrent = false,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) => EducationModel(
        institute: json['institute']?.toString() ?? '',
        degree: json['degree']?.toString() ?? '',
        major: json['major']?.toString() ?? '',
        from: json['from']?.toString() ?? '',
        to: json['to']?.toString() ?? '',
        isCurrent: json['isCurrent'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'institute': institute,
        'degree': degree,
        'major': major,
        'from': from,
        'to': to,
        'isCurrent': isCurrent,
      };
}

class LocationModel {
  final String address;
  final bool isCurrent;

  LocationModel({this.address = '', this.isCurrent = false});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        address: json['address']?.toString() ?? '',
        isCurrent: json['isCurrent'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'address': address,
        'isCurrent': isCurrent,
      };
}

class ContactModel {
  final String phone;
  final String mobile;
  final String email;

  ContactModel({this.phone = '', this.mobile = '', this.email = ''});

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
        phone: json['phone']?.toString() ?? '',
        mobile: json['mobile']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'mobile': mobile,
        'email': email,
      };
}

class SocialLink {
  final String platform;
  final String url;

  SocialLink({this.platform = '', this.url = ''});

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
        platform: json['platform']?.toString() ?? '',
        url: json['url']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'platform': platform, 'url': url};
}

class ProfileModel {
  final String id;
  final String name;
  final String about;
  final String? avatar;
  final String? resumeUrl;
  final LocationModel? location;
  final ContactModel? contact;
  final List<AffiliationModel> affiliations;
  final List<EducationModel> education;
  final List<SocialLink> socialLinks;
  final List<String> personalWebsites;

  ProfileModel({
    this.id = '',
    this.name = '',
    this.about = '',
    this.avatar,
    this.resumeUrl,
    this.location,
    this.contact,
    this.affiliations = const [],
    this.education = const [],
    this.socialLinks = const [],
    this.personalWebsites = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json['_id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        about: json['about']?.toString() ?? '',
        avatar: json['avatar']?.toString(),
        resumeUrl: json['resumeUrl'] as String? ??
            (json['resume'] is Map
                ? (json['resume'] as Map<String, dynamic>)['url'] as String?
                : json['resume'] as String?),
        location: json['location'] is Map
            ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
            : null,
        contact: json['contact'] is Map
            ? ContactModel.fromJson(json['contact'] as Map<String, dynamic>)
            : null,
        affiliations: (json['affiliations'] as List? ?? [])
            .map((e) => AffiliationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        education: (json['education'] as List? ?? [])
            .map((e) => EducationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        socialLinks: (json['socialLinks'] as List? ?? [])
            .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
            .toList(),
        personalWebsites: (json['personalWebsites'] as List? ?? [])
            .map((e) => e.toString())
            .toList(),
      );
}
