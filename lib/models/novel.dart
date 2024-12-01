class Novel {
  final String slug;
  final String title;
  final String description;
  final String authorName;
  final int authorId; // New field for author ID
  final String releasedAt;
  final String status;
  final String thumbnailImageUrl;
  final int readCounts;
  final int totalChapters;
  final double averageRatings;
  final int likeCounts;
  final List<String> genreNames;
  final bool closed;
  final bool liked;

  // Updated constructor with the new 'authorId' field
  Novel({
    required this.slug,
    required this.title,
    required this.description,
    required this.authorName,
    required this.authorId, // New required parameter
    required this.releasedAt,
    required this.status,
    required this.thumbnailImageUrl,
    required this.readCounts,
    required this.totalChapters,
    required this.averageRatings,
    required this.likeCounts,
    required this.genreNames,
    required this.closed,
    required this.liked,
  });

  // Updated fromJson factory method to handle the 'authorId' field
  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      authorName: json['authorName'] ?? '',
      authorId: json['authorId'] ?? 0, // Default to 0 if 'authorId' is missing
      releasedAt: json['releasedAt'] ?? '',
      status: json['status'] ?? '',
      thumbnailImageUrl: json['thumbnailImageUrl'] ?? '',
      readCounts: json['readCounts'] ?? 0,
      totalChapters: json['totalChapters'] ?? 0,
      averageRatings: (json['averageRatings'] as num?)?.toDouble() ?? 0.0,
      likeCounts: json['likeCounts'] ?? 0,
      genreNames: List<String>.from(json['genreNames'] ?? []),
      closed: json['closed'] ?? false,
      liked: json['liked'] ?? false,
    );
  }

  // Method to convert the Novel object to a map
  Map<String, dynamic> toMap() {
    return {
      'slug': slug,
      'title': title,
      'description': description,
      'authorName': authorName,
      'authorId': authorId, // Include 'authorId' in the map
      'releasedAt': releasedAt,
      'status': status,
      'thumbnailImageUrl': thumbnailImageUrl,
      'readCounts': readCounts,
      'totalChapters': totalChapters,
      'averageRatings': averageRatings,
      'likeCounts': likeCounts,
      'genreNames': genreNames,
      'closed': closed,
      'liked': liked,
    };
  }
}
