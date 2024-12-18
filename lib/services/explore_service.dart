import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/novel_model.dart';

class ExploreService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';

  Future<List<Novel>> fetchRecommendations() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/novels/recommend?userId=1&page=0&size=10'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = jsonResponse['content'];
        return data.map((json) => Novel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recommendations');
      }
    } catch (e) {
      print('Error fetching recommendations: $e');
      throw Exception('Failed to load recommendations');
    }
  }

  Future<List<Novel>> fetchNovelsByGenre(dynamic genreIdentifier) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final String endpoint;
      if (genreIdentifier is String) {
        final encodedGenre = Uri.encodeComponent(genreIdentifier);
        endpoint = '$baseUrl/novels/genre/$encodedGenre';
      } else {
        endpoint = '$baseUrl/novels/filter-by-genre?genreIds=${genreIdentifier.join(",")}';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> novels = data['content'] as List<dynamic>;
        return novels.map((json) => Novel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load novels');
      }
    } catch (e) {
      print('Error fetching novels by genre: $e');
      throw Exception('Failed to load novels');
    }
  }

  Future<List<String>> fetchGenres() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/genres/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> genresJson = jsonDecode(utf8.decode(response.bodyBytes));
        return genresJson.map((genre) => genre['name'] as String).toList();
      } else {
        throw Exception('Failed to load genres: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching genres: $e');
      throw Exception('Failed to load genres');
    }
  }

  Future<List<Novel>> searchNovelsByAuthor(String authorName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/novels/search/by-author?authorName=$authorName'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = jsonResponse['content'];
        return data.map((json) => Novel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search novels by author');
      }
    } catch (e) {
      print('Error searching novels by author: $e');
      throw Exception('Failed to search novels by author');
    }
  }

  Future<List<Novel>> searchNovelsByTitle(String title) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/novels/search/by-title?title=$title'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        List<dynamic> data = jsonResponse['content'];
        return data.map((json) => Novel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search novels by title');
      }
    } catch (e) {
      print('Error searching novels by title: $e');
      throw Exception('Failed to search novels by title');
    }
  }
}