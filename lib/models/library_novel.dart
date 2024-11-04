// lib/models/library_novel.dart

import 'package:flutter/material.dart';

class LibraryNovel {
  final String title;
  final String authorName;
  final String thumbnailImageUrl;
  final String slug;
  final String subtitle;
  final IconData trailingIcon;
  final String primaryGenre;

  LibraryNovel({
    required this.title,
    required this.authorName,
    required this.thumbnailImageUrl,
    required this.slug,
    required this.subtitle,
    required this.trailingIcon,
    required this.primaryGenre,
  });

  factory LibraryNovel.fromJson(Map<String, dynamic> json, {IconData? icon, String? subtitle}) {
    return LibraryNovel(
      title: json['title'] ?? '',
      authorName: json['authorName'] ?? '',
      thumbnailImageUrl: json['thumbnailImageUrl'] ?? '',
      slug: json['slug'] ?? '',
      subtitle: subtitle ?? json['authorName'] ?? '',
      trailingIcon: icon ?? Icons.more_vert,
      primaryGenre: (json['genreNames'] as List<dynamic>?)?.isNotEmpty == true
          ? json['genreNames'][0]
          : 'Unknown',
    );
  }
}