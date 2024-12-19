// ranking_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/screens/self_screen/event/ranking_user.dart';

class RankingService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';

  static Future<Map<String, String>> getAuthHeaders() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Vui lòng đăng nhập để xem bảng xếp hạng');
      }

      return {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
    } catch (e) {
      throw Exception('Lỗi xác thực: $e');
    }
  }

  // In ranking_service.dart

  static Future<List<RankingUser>> fetchTopReaders() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bxh/top-read'),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => RankingUser.fromJson(json)).toList();
      } else {
        handleApiError(response);
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching top readers: $e');
    }
  }

  static Future<List<RankingUser>> fetchTopNovels() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/novels/bxh/top-read'),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
        if (responseData['content'] is List) {
          final List<dynamic> data = responseData['content'] as List<dynamic>;
          return data.map((json) => RankingUser.fromJson(json)).toList();
        }
        return [];
      } else {
        handleApiError(response);
        return [];
      }
    } catch (e) {
      throw Exception('Lỗi khi tải bảng xếp hạng truyện: $e');
    }
  }

  static Future<List<RankingUser>> fetchTopUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bxh/top-point'),
        headers: await getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((json) => RankingUser.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top users');
      }
    } catch (e) {
      throw Exception('Error fetching top users: $e');
    }
  }
  static void handleApiError(http.Response response) {
    if (response.statusCode == 401) {
      throw Exception('Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.');
    } else if (response.statusCode == 403) {
      throw Exception('Bạn không có quyền truy cập nội dung này.');
    } else if (response.statusCode >= 500) {
      throw Exception('Lỗi máy chủ. Vui lòng thử lại sau.');
    } else {
      throw Exception('Lỗi không xác định (${response.statusCode})');
    }
  }
}