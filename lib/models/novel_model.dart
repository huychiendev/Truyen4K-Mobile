class Novel {
  final String slug;
  final String title;
  final String description;
  final String thumbnailImageUrl;
  final double averageRatings;

  Novel({
    required this.slug,
    required this.title,
    required this.description,
    required this.thumbnailImageUrl,
    required this.averageRatings,
  });

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      slug: json['slug'],
      title: json['title'],
      description: json['description'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      averageRatings: json['averageRatings'],
    );
  }
}