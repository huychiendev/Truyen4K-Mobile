class Comment {
  final int id;
  final String content;
  final String username;
  final String? userImagePath;
  final DateTime createdAt;
  final int? parentId;

  Comment({
    required this.id,
    required this.content,
    required this.username,
    this.userImagePath,
    required this.createdAt,
    this.parentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      username: json['username'],
      userImagePath: json['user_image_path'],
      createdAt: DateTime.parse(json['createdAt']),
      parentId: json['parentId'],
    );
  }
}
