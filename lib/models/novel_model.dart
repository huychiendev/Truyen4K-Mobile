class Novel {
  final String slug;
  final String title;
  final String description;
  final String thumbnailImageUrl;
  final double averageRatings;
  final String authorName; // Add this line

  Novel({
    required this.slug,
    required this.title,
    required this.description,
    required this.thumbnailImageUrl,
    required this.averageRatings,
    required this.authorName, // Add this line
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      averageRatings: json['averageRatings'],
      authorName: json['authorName'], // Add this line
    );
  }
}
