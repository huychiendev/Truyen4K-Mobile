class Novel {
  final String slug;
  final String title;
  final String description;
  final String releasedAt;
  final String status;
  final String thumbnailImageUrl;
  final int readCounts;
  final int totalChapters;
  final double averageRatings;
  final int likeCounts;
  final String authorName;
  final List<String> genreNames;
  final bool closed;
  final bool liked;

  Novel({
    required this.slug,
    required this.title,
    required this.description,
    required this.releasedAt,
    required this.status,
    required this.thumbnailImageUrl,
    required this.readCounts,
    required this.totalChapters,
    required this.averageRatings,
    required this.likeCounts,
    required this.authorName,
    required this.genreNames,
    required this.closed,
    required this.liked,
  });

  // Thêm method toMap()
  Map<String, dynamic> toMap() {
    return {
      'slug': slug,
      'title': title,
      'description': description,
      'releasedAt': releasedAt,
      'status': status,
      'thumbnailImageUrl': thumbnailImageUrl,
      'readCounts': readCounts,
      'totalChapters': totalChapters,
      'averageRatings': averageRatings,
      'likeCounts': likeCounts,
      'authorName': authorName,
      'genreNames': genreNames,
      'closed': closed,
      'liked': liked,
    };
  }

  // Giữ nguyên factory method fromJson
  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releasedAt: json['releasedAt'] ?? '',
      status: json['status'] ?? '',
      thumbnailImageUrl: json['thumbnailImageUrl'] ?? '',
      readCounts: json['readCounts'] ?? 0,
      totalChapters: json['totalChapters'] ?? 0,
      averageRatings: (json['averageRatings'] as num?)?.toDouble() ?? 0.0,
      likeCounts: json['likeCounts'] ?? 0,
      authorName: json['authorName'] ?? '',
      genreNames: List<String>.from(json['genreNames'] ?? []),
      closed: json['closed'] ?? false,
      liked: json['liked'] ?? false,
    );
  }
}