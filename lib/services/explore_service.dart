import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/novel_model.dart';

class ExploreService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1/novels/recommend?userId=1&page=0&size=10';

  // Thêm method mới cho recommendations
  Future<List<Novel>> fetchRecommendations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/novels/recommend?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  Future<List<Novel>> fetchNovelsByGenre(List<int> genreIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://14.225.207.58:9898/api/v1/novels/filter-by-genre?genreIds=${genreIds.join(",")}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data =
      jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
  }

  Future<List<String>> fetchGenres() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/genres/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> genresJson = jsonDecode(utf8.decode(response.bodyBytes));
      return genresJson.map((genre) => genre['name'] as String).toList();
    } else {
      throw Exception(
          'Failed to load genres: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Novel>> searchNovelsByAuthor(String authorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/novels/search/by-author?authorName=$authorName'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search novels by author');
    }
  }

  Future<List<Novel>> searchNovelsByTitle(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/novels/search/by-title?title=$title'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search novels by title');
    }
  }

}