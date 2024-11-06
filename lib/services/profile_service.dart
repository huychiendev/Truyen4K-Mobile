// profile_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/models/ProfileModel.dart';

class ProfileService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';

  // profile_service.dart

  static Future<UserProfile> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');

    if (token == null || username == null) {
      throw Exception('No authentication token or username found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/profile/$username'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final profileData = json.decode(utf8.decode(response.bodyBytes));
      UserProfile userProfile = UserProfile.fromJson(profileData);

      // Fetch user image
      if (userProfile.id != null) {
        final imageResponse = await http.get(
          Uri.parse('$baseUrl/images/?userId=${userProfile.id}'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (imageResponse.statusCode == 200) {
          final List<dynamic> imageData = json.decode(utf8.decode(imageResponse.bodyBytes));
          if (imageData.isNotEmpty) {
            return userProfile.copyWith(
              data: imageData[0]['data'],
              // Có thể thêm các trường khác nếu cần
            );
          }
        }
      }

      return userProfile;
    } else {
      throw Exception('Failed to load profile data');
    }
  }
}