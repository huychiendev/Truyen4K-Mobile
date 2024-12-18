import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NovelInteractionService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';

  // Lấy thông tin header xác thực
  static Future<Map<String, String>> getAuthHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  static Future<bool> checkIfSaved(String slug) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/liked-novels/check-saved/$slug'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['saved'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking saved status: $e');
      return false;
    }
  }

  static Future<bool> saveNovelToLibrary(String slug) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      final response = await http.post(
        Uri.parse('$baseUrl/liked-novels/save-to-library'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'slug': slug}),
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        final errorResponse = jsonDecode(response.body);
        if (errorResponse['status'] == 'NOT_FOUND' &&
            errorResponse['message'].contains('already exists')) {
          return true; // Truyện đã được lưu trước đó
        }
        throw Exception('Novel not found');
      } else {
        throw Exception('Failed to save novel');
      }
    } catch (e) {
      print('Error saving novel to library: $e');
      throw e;
    }
  }

  // Thích truyện (POST)
  static Future<bool> likeNovel(String slug) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      // Kiểm tra nếu `userId` không tồn tại
      if (userId == null) {
        print('User ID is null. Vui lòng đăng nhập.');
        throw Exception('User ID is null');
      }

      final url = '$baseUrl/novels/like/$slug?userId=$userId';
      print('Sending POST request to: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: await getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final responseBody = response.body.toLowerCase();
        return responseBody == 'true';
      } else {
        print('Error liking novel: Status code ${response.statusCode}');
        throw Exception('Failed to like novel');
      }
    } catch (e) {
      print('Lỗi thích truyện: $e');
      throw Exception('Không thể thích truyện');
    }
  }


  static Future<bool> checkIfLiked(String slug) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');

      if (userId == null) throw Exception('User ID is null');

      final url = '$baseUrl/novels/$slug/is-liked?userId=$userId';
      print('Sending GET request to: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: await getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        return responseBody['liked'] ?? false;
      } else {
        print('Error checking like status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in checkIfLiked: $e');
      return false;
    }
  }

}
