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
  final String? data;
  final int coinBalance; // Add this
  final int diamondBalance; // Add this

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
    this.data,
    this.coinBalance = 0, // Default value
    this.diamondBalance = 0, // Default value
  });

  // Update fromJson method
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
      data: json['data'],
      coinBalance: json['coinBalance'] ?? 0,
      diamondBalance: json['diamondBalance'] ?? 0,
    );
  }
}