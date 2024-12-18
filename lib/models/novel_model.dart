class Novel {
  final String slug;
  final String title;
  final String description;
  final String thumbnailImageUrl;
  final double averageRatings;
  final String authorName;
  final int totalChapters;

  Novel({
    required this.slug,
    required this.title,
    required this.description,
    required this.thumbnailImageUrl,
    required this.averageRatings,
    required this.authorName,
    required this.totalChapters,
  });

// In novel_model.dart
  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnailImageUrl: json['thumbnailImageUrl'] ?? '',
      averageRatings: (json['averageRatings'] as num?)?.toDouble() ?? 0.0,
      authorName: json['authorName'] ?? 'Không xác định',
      totalChapters: json['totalChapters'] ?? 0,
    );
  }
}