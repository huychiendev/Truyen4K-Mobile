class UserProfile {
  final int id;
  final String username;
  final String email;
  final String accountStatus;
  final int chapterReadCount;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;
  final String tierName;

  UserProfile({
    required this.id,
    required this.username,
    required this.email,
    required this.accountStatus,
    required this.chapterReadCount,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
    required this.tierName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      accountStatus: json['accountStatus'],
      chapterReadCount: json['chapterReadCount'],
      imagePath: json['imagePath'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      tierName: json['tierName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'accountStatus': accountStatus,
      'chapterReadCount': chapterReadCount,
      'imagePath': imagePath,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'tierName': tierName,
    };
  }
}