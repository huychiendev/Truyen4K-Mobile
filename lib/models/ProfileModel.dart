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
  final int followerCount;
  final String dayLeft;
  final int coinWallet;
  final int coinSpent;

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
    this.data,
    this.coinBalance = 0,
    this.diamondBalance = 0,
    this.followerCount = 0,
    this.dayLeft = 'Bạn chưa mua gói premium',
    this.coinWallet = 0,
    this.coinSpent = 0,
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
      data: json['data'],
      coinBalance: json['coinBalance'] ?? 0,
      diamondBalance: json['diamondBalance'] ?? 0,
      followerCount: json['followerCount'] ?? 0,
      dayLeft: json['dayLeft'] ?? 'Bạn chưa mua gói premium',
      coinWallet: json['coinWallet'] ?? 0,
      coinSpent: json['coinSpent'] ?? 0,
    );
  }
  // Thêm vào class UserProfile
  UserProfile copyWith({
    String? data,
    int? coinBalance,
    int? diamondBalance,
    int? followerCount,
    String? dayLeft,
    int? coinWallet,
    int? coinSpent,
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
      followerCount: followerCount ?? this.followerCount,
      dayLeft: dayLeft ?? this.dayLeft,
      coinWallet: coinWallet ?? this.coinWallet,
      coinSpent: coinSpent ?? this.coinSpent,
    );
  }
}