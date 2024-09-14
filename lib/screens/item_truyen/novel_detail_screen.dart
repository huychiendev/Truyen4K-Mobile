import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'chapter_detail_screen.dart';

class NovelDetailScreen extends StatefulWidget {
  final String slug;

  const NovelDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  _NovelDetailScreenState createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  Map<String, dynamic>? novelData;

  @override
  void initState() {
    super.initState();
    _fetchNovelDetails();
  }

  Future<void> _fetchNovelDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/novels/${widget.slug}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        novelData = jsonDecode(utf8.decode(response.bodyBytes));
      });
    } else {
      throw Exception('Failed to load novel details');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (novelData == null) {
      return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text('Loading...'),
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final uniqueGenres = novelData!['genreNames'].toSet().toList();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          novelData!['title'] ?? 'Novel Details',
          style: TextStyle(color: Colors.white), // Updated text color
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCoverImage(novelData!['thumbnailImageUrl'] ?? ''),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          novelData!['title'] ?? 'Unknown Title',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Truyện chưa được note lại đâu nhá !'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text('Tác giả: ' + novelData!['authorName'] ?? 'Unknown Author',
                      style: TextStyle(fontSize: 16, color: Colors.white70)),
                  Text('${novelData!['totalChapters'] ?? 'Unknown'} Chương',
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  _buildStatsRow(
                      novelData!['readCounts']?.toString() ?? 'Unknown',
                      (novelData!['averageRatings'] as num?)?.toDouble() ?? 0.0,
                      (novelData!['likeCounts'] as num?)?.toInt() ?? 0),
                  SizedBox(height: 16),
                  Text(
                    'Về cuốn truyện này',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    novelData!['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 16),
                  _buildTags(uniqueGenres),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(String imageUrl) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 250,
              color: Colors.grey,
              child: Center(child: Text('Image not available', style: TextStyle(color: Colors.white))),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black.withOpacity(0.7),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.book, color: Colors.white),
                    label: Text('Đọc tiếp', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailScreen(
                            slug: widget.slug,
                            chapterNo: 1, // Start with the first chapter
                            novelName: novelData!['title'] ?? 'Unknown Title',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF232538),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.headphones, color: Colors.white),
                    label: Text('Nghe Tiếp', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailScreen(
                            slug: widget.slug,
                            chapterNo: 1, // Start with the first chapter
                            novelName: novelData!['title'] ?? 'Unknown Title',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF232538),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(String readCounts, double rating, int likes) {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(readCounts, style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.star, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(rating.toStringAsFixed(1), style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.thumb_up, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text('${likes}K', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildTags(List<dynamic> tags) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) => _buildTag(tag.toString())).toList(),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(tag, style: TextStyle(color: Colors.white)),
    );
  }
}