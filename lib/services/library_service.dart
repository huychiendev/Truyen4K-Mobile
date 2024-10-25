import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';
import '../models/library_novel.dart';

class LibraryService {
  Future<List<LibraryNovel>> fetchNovels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://14.225.207.58:9898/api/novels/new-released?page=0&size=20'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      List<dynamic> novelsJson = data['content'];
      novelsJson.shuffle(Random());
      return novelsJson.map((json) => LibraryNovel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load new released novels');
    }
  }

  Future<List<LibraryNovel>> fetchSavedNovels() async {
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
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/novels/$slug'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          novels.add(LibraryNovel.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)),
              icon: Icons.more_vert));
        } else {
          throw Exception('Failed to load novel details');
        }
      }
    }

    return novels;
  }
}