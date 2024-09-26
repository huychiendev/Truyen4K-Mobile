class Novel {
  final String slug;
  final String title;
  final String authorName;
  final String thumbnailImageUrl;
  final String description;
  final int totalChapters;
  final int readCounts;
  final double averageRatings;
  final int likeCounts;
  final List<String> genreNames;

  Novel({
    required this.slug,
    required this.title,
    required this.authorName,
    required this.thumbnailImageUrl,
    required this.description,
    required this.totalChapters,
    required this.readCounts,
    required this.averageRatings,
    required this.likeCounts,
    required this.genreNames,
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      authorName: json['authorName'] ?? '',
      thumbnailImageUrl: json['thumbnailImageUrl'] ?? '',
      description: json['description'] ?? '',
      totalChapters: json['totalChapters'] ?? 0,
      readCounts: json['readCounts'] ?? 0,
      averageRatings: (json['averageRatings'] as num?)?.toDouble() ?? 0.0,
      likeCounts: json['likeCounts'] ?? 0,
      genreNames: List<String>.from(json['genreNames'] ?? []),
    );
  }
}