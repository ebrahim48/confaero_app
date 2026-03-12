class UserModel {
  final String id;
  final String name;
  final String email;
  final List<String> roles;
  final String activeRole;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.activeRole,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
      activeRole: json['activeRole'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'activeRole': activeRole,
      'profileImage': profileImage,
    };
  }
}
