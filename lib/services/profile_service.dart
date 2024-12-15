import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/ProfileModel.dart';
import '../models/User.dart';

class ProfileService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';

  static Future<Map<String, dynamic>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');

    if (token == null || username == null) {
      throw Exception('No authentication token or username found');
    }

    // Fetch profile data
    final profileResponse = await http.get(
      Uri.parse('$baseUrl/profile/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (profileResponse.statusCode == 200) {
      final profileData = json.decode(utf8.decode(profileResponse.bodyBytes));
      final userProfile = UserProfile.fromJson(profileData);

      // Fetch user image
      final imageResponse = await http.get(
        Uri.parse('$baseUrl/images/?userId=${userProfile.id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (imageResponse.statusCode == 200) {
        final List<dynamic> images = json.decode(utf8.decode(imageResponse.bodyBytes));
        if (images.isNotEmpty) {
          return {
            'profile': userProfile,
            'image': UserImage(
              id: images[0]['id'] ?? 0,
              type: images[0]['type'] ?? 'image/jpeg',
              data: images[0]['data'],
              createdAt: images[0]['createdAt'] ?? DateTime.now().toIso8601String(),
              user: userProfile,
            ),
          };
        }
      }

      return {
        'profile': userProfile,
        'image': null,
      };
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}