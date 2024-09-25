import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataService {
  static Future<Map<String, dynamic>> loadData() async {
    final jsonString = await rootBundle.loadString('assets/mock_data.json');
    return json.decode(jsonString) as Map<String, dynamic>;
  }

  static Future<List<dynamic>> fetchTrendingNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/trending?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['content'] as List<dynamic>;
    } else {
      throw Exception('Failed to load trending novels');
    }
  }



  Future<Map<String, dynamic>> fetchChapterDetails(String slug, String chapterNo) async {
    final response = await http.get(Uri.parse('http://14.225.207.58:9898/api/chapters/$slug/$chapterNo'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load chapter details');
    }
  }


  Future<Map<String, dynamic>> fetchAudioFileDetails(int chapterId) async {
    final response = await http.get(Uri.parse('http://14.225.207.58:9898/api/audio-files/$chapterId'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load audio file details');
    }
  }
}
