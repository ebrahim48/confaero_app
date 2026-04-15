class SocialLink {
  final String platform;
  final String url;

  SocialLink({this.platform = '', this.url = ''});

  factory SocialLink.fromJson(Map<String, dynamic> json) {
    return SocialLink(
      platform: json['platform'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'platform': platform, 'url': url};
}

class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String title;
  final String bio;
  final String company;
  final String? profileImage;
  final String? resumeUrl;
  final List<SocialLink> socialLinks;

  ProfileModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.title = '',
    this.bio = '',
    this.company = '',
    this.profileImage,
    this.resumeUrl,
    this.socialLinks = const [],
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['_id'] ?? '',
      firstName: json['firstName'] ?? json['name'] ?? '',
      lastName: json['lastName'] ?? '',
      title: json['title'] ?? json['jobTitle'] ?? '',
      bio: json['bio'] ?? '',
      company: json['company'] ?? '',
      profileImage: json['profileImage'] ?? json['avatar'],
      resumeUrl: json['resumeUrl'] ?? json['resume'],
      socialLinks:
          json['socialLinks'] != null
              ? (json['socialLinks'] as List)
                  .map((e) => SocialLink.fromJson(e as Map<String, dynamic>))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': firstName,
      'lastName': lastName,
      'title': title,
      'bio': bio,
      'company': company,
      'profileImage': profileImage,
      'resumeUrl': resumeUrl,
      'socialLinks': socialLinks.map((e) => e.toJson()).toList(),
    };
  }
}
