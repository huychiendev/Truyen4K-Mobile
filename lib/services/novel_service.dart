import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/ReadingProgress.dart';
import '../models/comment.dart';
import '../models/library_novel.dart';
import '../models/novel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NovelService {
  static const String baseUrl = 'http://14.225.207.58:9898/api';

  static Future<Novel> fetchNovelDetails(String slug) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      int? userId = prefs.getInt('user_id');

      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/novels/$slug?userId=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final novelData = jsonDecode(utf8.decode(response.bodyBytes));
        return Novel.fromJson(novelData);
      } else {
        print('Error status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw Exception('Failed to load novel details');
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

 static Future<List<Comment>> fetchComments(String slug) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  final response = await http.get(
    Uri.parse('$baseUrl/comments/$slug'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> commentsJson = jsonDecode(utf8.decode(response.bodyBytes));
    List<Comment> comments = [];

    for (var commentJson in commentsJson) {
      int userId = commentJson['userId'];
      final userResponse = await http.get(
        Uri.parse('$baseUrl/images/?userId=$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (userResponse.statusCode == 200) {
        final List<dynamic> userJsonList = jsonDecode(utf8.decode(userResponse.bodyBytes));
        if (userJsonList.isNotEmpty) {
          final userJson = userJsonList[0];
          if (userJson != null && userJson['user'] != null && userJson['user']['tier'] != null) {
            commentJson['tierName'] = userJson['user']['tier']['name'];
            commentJson['userImageData'] = userJson['data'];
          }
        }
      } else {
        print('Failed to fetch user data for userId: $userId');
      }

      comments.add(Comment.fromJson(commentJson));
    }

    return comments;
  } else {
    throw Exception('Failed to load comments');
  }
}


  static Future<void> submitComment(String slug, String content, int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('$baseUrl/comments/post-comment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        'slug': slug,
        'userId': userId,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to submit comment');
    }
  }

  static Future<List<dynamic>> fetchTopReadNovels2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/top-read?page=0&size=10'),
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
  static Future<void> deleteComment(int commentId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.delete(
      Uri.parse('http://14.225.207.58:9898/api/comments/$commentId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
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
          Uri.parse('http://14.225.207.58:9898/api/novels/$slug'),
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
          Uri.parse('http://14.225.207.58:9898/api/novels/$slug'),
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