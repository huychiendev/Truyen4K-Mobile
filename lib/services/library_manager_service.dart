import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/library_novel.dart';

class LibraryManagerService {
  static const String baseUrl = 'http://14.225.207.58:9898/api';

  // Fetch saved novels
  static Future<List<LibraryNovel>> fetchSavedNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');
    String key = 'saved_items';

    if (username == null) {
      throw Exception('Username not found');
    }

    List<String> savedItems = prefs.getStringList(key) ?? [];
    List<LibraryNovel> novels = [];

    for (String item in savedItems) {
      if (item.startsWith('$username,')) {
        String slug = item.split(',')[1];
        try {
          final response = await http.get(
            Uri.parse('$baseUrl/novels/$slug'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          ).timeout(Duration(seconds: 10));

          if (response.statusCode == 200) {
            novels.add(LibraryNovel.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)),
              icon: Icons.more_vert,
              subtitle: 'Đã lưu',
            ));
          }
        } catch (e) {
          print('Error fetching saved novel $slug: $e');
          continue;
        }
      }
    }
    return novels;
  }

  // Fetch reading progress
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

        try {
          final response = await http.get(
            Uri.parse('$baseUrl/novels/$slug'),
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
          }
        } catch (e) {
          print('Error fetching reading progress for $slug: $e');
          continue;
        }
      }
    }
    return novels;
  }

  // Fetch completed novels
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

        try {
          final response = await http.get(
            Uri.parse('$baseUrl/novels/$slug'),
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
                icon: Icons.check_circle,
                subtitle: 'Đã đọc xong',
              ));
            }
          }
        } catch (e) {
          print('Error fetching completed novel $slug: $e');
          continue;
        }
      }
    }
    return novels;
  }

  // Update reading progress
  static Future<void> updateReadingProgress(String slug, int chapterNo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String key = 'reading_progress';

    if (username == null) {
      throw Exception('Username not found');
    }

    List<String> progressItems = prefs.getStringList(key) ?? [];
    // Remove old progress if exists
    progressItems.removeWhere((item) => item.startsWith('$username,$slug,'));
    // Add new progress
    progressItems.add('$username,$slug,$chapterNo,${DateTime.now().millisecondsSinceEpoch}');
    await prefs.setStringList(key, progressItems);
  }
}