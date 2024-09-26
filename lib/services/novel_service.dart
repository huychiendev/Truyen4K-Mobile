import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/novel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovelService {
  static const String baseUrl = 'http://14.225.207.58:9898/api';

  static Future<Novel> fetchNovelDetails(String slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/novels/$slug'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final novelData = jsonDecode(utf8.decode(response.bodyBytes));
      return Novel.fromJson(novelData);
    } else {
      throw Exception('Failed to load novel details');
    }
  }

  static Future<List<Novel>> fetchTopReadNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/novels/top-read'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> novelsData = jsonDecode(utf8.decode(response.bodyBytes));
      return novelsData.map((data) => Novel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load top read novels');
    }
  }

  static Future<bool> checkIfSaved(String slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String key = 'saved_items';

    if (username != null) {
      List<String> savedItems = prefs.getStringList(key) ?? [];
      String item = '$username,$slug';
      return savedItems.contains(item);
    }
    return false;
  }

  static Future<bool> toggleSave(String slug) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String key = 'saved_items';

    if (username != null) {
      List<String> savedItems = prefs.getStringList(key) ?? [];
      String item = '$username,$slug';

      if (savedItems.contains(item)) {
        savedItems.remove(item);
      } else {
        savedItems.add(item);
      }

      await prefs.setStringList(key, savedItems);
      return savedItems.contains(item);
    }
    throw Exception('User not logged in');
  }
}
