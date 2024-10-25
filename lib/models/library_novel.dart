import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class LibraryNovel {
  final String title;
  final String authorName;
  final String thumbnailImageUrl;
  final String slug;
  final String subtitle;
  final IconData trailingIcon;

  LibraryNovel({
    required this.title,
    required this.authorName,
    required this.thumbnailImageUrl,
    required this.slug,
    required this.subtitle,
    required this.trailingIcon,
  });

  factory LibraryNovel.fromJson(Map<String, dynamic> json, {IconData? icon, String? subtitle}) {
    return LibraryNovel(
      title: json['title'],
      authorName: json['authorName'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      slug: json['slug'],
      subtitle: subtitle ?? json['authorName'],
      trailingIcon: icon ?? Icons.more_vert,
    );
  }

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
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/novels/$slug'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          novels.add(LibraryNovel.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)),
            icon: Icons.more_vert,
            subtitle: 'Đã lưu',
          ));
        } else {
          throw Exception('Failed to load novel details');
        }
      }
    }

    return novels;
  }
}