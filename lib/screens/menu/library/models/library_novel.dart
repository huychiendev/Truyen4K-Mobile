import 'package:flutter/material.dart';

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

  factory LibraryNovel.fromJson(Map<String, dynamic> json, {IconData? icon}) {
    return LibraryNovel(
      title: json['title'],
      authorName: json['authorName'],
      thumbnailImageUrl: json['thumbnailImageUrl'],
      slug: json['slug'],
      subtitle: json['authorName'],
      trailingIcon: icon ?? Icons.more_vert,
    );
  }
}