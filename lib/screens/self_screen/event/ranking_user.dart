class RankingUser {
  final int userId;
  final String fullName;
  final String imagePath;
  final int chapterReadCount;
  final String tierName;
  final int? point;
  final String? slug;
  final String? title;
  final int? readCounts;

  RankingUser({
    required this.userId,
    required this.fullName,
    required this.imagePath,
    this.chapterReadCount = 0,
    required this.tierName,
    this.point,
    this.slug,
    this.title,
    this.readCounts,
  });

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      userId: json['userId'] ?? 0,
      fullName: json['fullName'] ?? json['title'] ?? 'Unknown',
      imagePath: json['imagePath'] ?? json['thumbnailImageUrl'] ?? '',
      chapterReadCount: json['chapterReadCount'] ?? json['readCounts'] ?? 0,
      tierName: json['tierName'] ?? '',
      point: json['point'],
      slug: json['slug'],
      title: json['title'],
      readCounts: json['readCounts'],
    );
  }
}