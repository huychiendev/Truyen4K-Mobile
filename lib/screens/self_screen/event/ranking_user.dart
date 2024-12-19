class RankingUser {
  final int userId;
  final String fullName;
  final String imagePath;
  final int chapterReadCount;
  final String tierName;

  RankingUser({
    required this.userId,
    required this.fullName,
    required this.imagePath,
    required this.chapterReadCount,
    required this.tierName,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      userId: json['userId'],
      fullName: json['fullName'],
      imagePath: json['imagePath'],
      chapterReadCount: json['chapterReadCount'],
      tierName: json['tierName'],
    );
  }
}