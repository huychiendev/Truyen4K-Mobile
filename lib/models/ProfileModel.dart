// models/ProfileModel.dart

class UserProfile {
  final int id;
  final String? fullName;
  final String username;
  final String email;
  final String accountStatus;
  final int point;
  final int chapterReadCount;
  final String? imagePath;
  final String? createdAt;
  final String? updatedAt;
  final String tierName;
  final List<int>? selectedGenreIds;
  final List<String>? hobbyNames;
  final String? data; // Thêm trường data
  final int coinBalance; // Thêm trường coinBalance
  final int diamondBalance; // Thêm trường diamondBalance

  UserProfile({
    required this.id,
    this.fullName,
    required this.username,
    required this.email,
    required this.accountStatus,
    required this.point,
    required this.chapterReadCount,
    this.imagePath,
    this.createdAt,
    this.updatedAt,
    required this.tierName,
    this.selectedGenreIds,
    this.hobbyNames,
    this.data, // Thêm parameter
    this.coinBalance = 0, // Thêm parameter với giá trị mặc định
    this.diamondBalance = 0, // Thêm parameter với giá trị mặc định
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      accountStatus: json['accountStatus'],
      point: json['point'],
      chapterReadCount: json['chapterReadCount'],
      imagePath: json['imagePath'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      tierName: json['tierName'],
      selectedGenreIds: json['selectedGenreIds'] != null ?
      List<int>.from(json['selectedGenreIds']) : null,
      hobbyNames: json['hobbyNames'] != null ?
      List<String>.from(json['hobbyNames']) : null,
      data: json['data'], // Thêm mapping
      coinBalance: json['coinBalance'] ?? 0, // Thêm mapping
      diamondBalance: json['diamondBalance'] ?? 0, // Thêm mapping
    );
  }
  // Thêm vào class UserProfile
  UserProfile copyWith({
    String? data,
    int? coinBalance,
    int? diamondBalance,
  }) {
    return UserProfile(
      id: this.id,
      username: this.username,
      email: this.email,
      accountStatus: this.accountStatus,
      point: this.point,
      chapterReadCount: this.chapterReadCount,
      imagePath: this.imagePath,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt,
      tierName: this.tierName,
      selectedGenreIds: this.selectedGenreIds,
      hobbyNames: this.hobbyNames,
      data: data ?? this.data,
      coinBalance: coinBalance ?? this.coinBalance,
      diamondBalance: diamondBalance ?? this.diamondBalance,
    );
  }
}