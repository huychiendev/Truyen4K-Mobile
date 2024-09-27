import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/novel_model.dart';

class ExploreService {
  Future<List<Novel>> fetchTopReadNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/top-read?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
  }

  Future<List<Novel>> fetchNovelsByGenre(List<int> genreIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/filter-by-genre?genreIds=${genreIds.join(",")}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes))['content'];
      return data.map((json) => Novel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load novels');
    }
  }
}