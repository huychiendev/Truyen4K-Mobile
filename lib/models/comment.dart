class Comment {
  final int id;
  final String content;
  final String createdAt;
  final int userId;
  final String? userImagePath;
  final String username;
  final int novelId;
  final String? tierName;
  final String? userImageData;

  Comment({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    this.userImagePath,
    required this.username,
    required this.novelId,
    this.tierName,
    this.userImageData,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      userImagePath: json['user_image_path'],
      username: json['username'],
      novelId: json['novelId'],
      tierName: json['tierName'],
      userImageData: json['userImageData'],
    );
  }
}