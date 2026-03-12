class ProfileModel {
  final String id;
  final String firstName;
  final String lastName;
  final String title;
  final String bio;
  final String company;
  final String? profileImage;
  final String? resumeUrl;
  final List<String> socialLinks;

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
              ? List<String>.from(json['socialLinks'])
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
      'socialLinks': socialLinks,
    };
  }
}
