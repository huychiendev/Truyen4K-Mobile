import 'package:apptruyenonline/models/User.dart';

class Comment {
  final int id;
  final String content;
  final String username;
  final int userId;  // Add this field
  final String? userImagePath;
  final DateTime createdAt;
  final int? parentId;
  List<Comment> replies;
  UserImage? userImage;  // Add this field

  Comment({
    required this.id,
    required this.content,
    required this.username,
    required this.userId,  // Add this
    this.userImagePath,
    required this.createdAt,
    this.parentId,
    this.replies = const [],
    this.userImage,  // Add this
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      username: json['username'],
      userId: json['userId'],  // Add this
      userImagePath: json['user_image_path'],
      createdAt: DateTime.parse(json['createdAt']),
      parentId: json['parentId'],
      replies: [],
      userImage: json['userImage'] != null ? UserImage.fromJson(json['userImage']) : null,  // Add this
    );
  }
}