class UserImage {
  final int id;
  final String data;
  final String type;
  final String createdAt;
  final User user;

  UserImage({
    required this.id,
    required this.data,
    required this.type,
    required this.createdAt,
    required this.user,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: json['id'],
      data: json['data'],
      type: json['type'],
      createdAt: json['createdAt'],
      user: User.fromJson(json['user']),
    );
  }
}

class User {
  final int id;
  final String username;
  final List<Role> roles;
  final String status;
  final String? imagePath;
  final int chapterReadCount;
  final String email;
  final String? otpCode;
  final String? createdAt;
  final String? updatedAt;
  final Tier tier;

  User({
    required this.id,
    required this.username,
    required this.roles,
    required this.status,
    this.imagePath,
    required this.chapterReadCount,
    required this.email,
    this.otpCode,
    this.createdAt,
    this.updatedAt,
    required this.tier,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var rolesFromJson = json['roles'] as List;
    List<Role> roleList = rolesFromJson.map((role) => Role.fromJson(role)).toList();

    return User(
      id: json['id'],
      username: json['username'],
      roles: roleList,
      status: json['status'],
      imagePath: json['imagePath'],
      chapterReadCount: json['chapterReadCount'],
      email: json['email'],
      otpCode: json['otpCode'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      tier: Tier.fromJson(json['tier']),
    );
  }

  String get tierName => tier.description;
}

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Tier {
  final int id;
  final String? iconPath;
  final int readCountRequired;
  final String description;

  Tier({
    required this.id,
    this.iconPath,
    required this.readCountRequired,
    required this.description,
  });

  factory Tier.fromJson(Map<String, dynamic> json) {
    return Tier(
      id: json['id'],
      iconPath: json['iconPath'],
      readCountRequired: json['readCountRequired'],
      description: json['description'],
    );
  }
}