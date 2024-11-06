// models/User.dart
import 'ProfileModel.dart';

class UserImage {
  final int id;
  final String type;
  final String data;
  final String createdAt;
  final UserProfile user;

  UserImage({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    required this.user,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      id: json['id'],
      type: json['type'],
      data: json['data'],
      createdAt: json['createdAt'],
      user: UserProfile.fromJson(json['user']),
    );
  }
}