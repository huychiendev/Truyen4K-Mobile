import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReadingProgress {
  final String username;
  final String slug;
  final int chapterNo;
  final int timestamp;

  ReadingProgress({
    required this.username,
    required this.slug,
    required this.chapterNo,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'slug': slug,
        'chapterNo': chapterNo,
        'timestamp': timestamp,
      };

  static ReadingProgress fromJson(Map<String, dynamic> json) => ReadingProgress(
        username: json['username'],
        slug: json['slug'],
        chapterNo: json['chapterNo'],
        timestamp: json['timestamp'],
      );
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