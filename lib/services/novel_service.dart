import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ReadingProgress.dart';
import '../models/library_novel.dart';
import '../models/novel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovelService {
  static const String baseUrl = 'http://14.225.207.58:9898/api/v1';

  // services/novel_service.dart
  static Future<Novel> fetchNovelDetails(String slug) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/novels/$slug?userId=1'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Request URL: ${response.request?.url}');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${utf8.decode(response.bodyBytes)}');

      if (response.statusCode == 200) {
        final novelData = jsonDecode(utf8.decode(response.bodyBytes));
        return Novel.fromJson(novelData);
      } else {
        throw Exception('Failed to load novel details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching novel details: $e');
      throw e;
    }
  }

  static Future<List<Novel>> fetchTopReadNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('$baseUrl/novels/top-read?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> novelsList = jsonResponse['content'];
      return novelsList.map((data) => Novel.fromJson(data)).toList();
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


  static Future<List<dynamic>> fetchTopReadNovels2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/novels/top-read?page=0&size=10'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data['content'] as List<dynamic>;
    } else {
      throw Exception('Failed to load top read novels');
    }
  }

  Future<void> saveReadingProgress(ReadingProgress progress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'reading_progress';
    List<String> progressItems = prefs.getStringList(key) ?? [];

    // Remove old progress for this novel if exists
    progressItems.removeWhere((item) => item.startsWith('${progress.username},${progress.slug},'));

    // Add new progress
    String item = '${progress.username},${progress.slug},${progress.chapterNo},${progress.timestamp}';
    progressItems.add(item);

    await prefs.setStringList(key, progressItems);
    print('Saved progress items: $progressItems'); // Debug print
  }

  static Future<List<LibraryNovel>> fetchReadingProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');
    String key = 'reading_progress';

    if (username == null) {
      throw Exception('Username not found');
    }

    List<String> progressItems = prefs.getStringList(key) ?? [];
    List<LibraryNovel> novels = [];

    for (String item in progressItems) {
      List<String> parts = item.split(',');
      if (parts[0] == username) {
        String slug = parts[1];
        int chapterNo = int.parse(parts[2]);
        int timestamp = int.parse(parts[3]);

        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/v1/novels/$slug'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          var novelJson = jsonDecode(utf8.decode(response.bodyBytes));
          int totalChapters = novelJson['totalChapters'];
          if (chapterNo < totalChapters) {
            novels.add(LibraryNovel.fromJson(
              novelJson,
              icon: Icons.book,
              subtitle: 'Đang đọc: Chương $chapterNo',
            ));
          }
        } else {
          throw Exception('Failed to load novel details');
        }
      }
    }

    print('Reading progress novels: $novels'); // Debug print
    return novels;
  }

  static Future<List<LibraryNovel>> fetchCompletedNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');
    String key = 'reading_progress';

    if (username == null) {
      throw Exception('Username not found');
    }

    List<String> progressItems = prefs.getStringList(key) ?? [];
    List<LibraryNovel> novels = [];

    for (String item in progressItems) {
      List<String> parts = item.split(',');
      if (parts[0] == username) {
        String slug = parts[1];
        int chapterNo = int.parse(parts[2]);
        int timestamp = int.parse(parts[3]);

        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/v1/novels/$slug'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          var novelJson = jsonDecode(utf8.decode(response.bodyBytes));
          int totalChapters = novelJson['totalChapters'];
          if (chapterNo >= totalChapters) {
            novels.add(LibraryNovel.fromJson(
              novelJson,
              icon: Icons.check,
              subtitle: 'Đã đọc xong',
            ));
          }
        } else {
          throw Exception('Failed to load novel details');
        }
      }
    }

    print('Completed novels: $novels'); // Debug print
    return novels;
  }
}