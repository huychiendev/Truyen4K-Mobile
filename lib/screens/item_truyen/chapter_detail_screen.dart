import 'package:apptruyenonline/models/ReadingProgress.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/screens/item_truyen/chapter_detail_screen.dart';


class ChapterDetailScreen extends StatefulWidget {
  final String slug;
  final int chapterNo;
  final String novelName;

  const ChapterDetailScreen({
    Key? key,
    required this.slug,
    required this.chapterNo,
    required this.novelName,
  }) : super(key: key);

  @override
  _ChapterDetailScreenState createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  Map<String, dynamic>? chapterData;

  @override
  void initState() {
    super.initState();
    _fetchChapterDetails();
  }

  Future<void> _fetchChapterDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String? username = prefs.getString('username');

    if (username == null) {
      throw Exception('Username not found');
    }

    final response = await http.get(
      Uri.parse('http://14.225.207.58:9898/api/v1/chapters/${widget.slug}/chap-${widget.chapterNo}'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        chapterData = jsonDecode(utf8.decode(response.bodyBytes));
      });

      // Save reading progress
      ReadingProgress progress = ReadingProgress(
        username: username,
        slug: widget.slug,
        chapterNo: widget.chapterNo,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      await saveReadingProgress(progress);

      // Print all keys and their values stored in SharedPreferences
      prefs.getKeys().forEach((key) {
        print('$key: ${prefs.get(key)}');
      });

    } else {
      throw Exception('Failed to load chapter details');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chapterData == null) {
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

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.novelName, style: TextStyle(fontSize: 16, color: Colors.white)),
            Text(chapterData!['title'] ?? 'Chapter Details', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chapterData!['title'] ?? 'Chapter Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 8),
            Text(
              'Chapter ${chapterData!['chapterNo']}',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              chapterData!['contentDoc'] ?? 'Chapter Content',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.chapterNo > 1)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterDetailScreen(
                            slug: widget.slug,
                            chapterNo: widget.chapterNo - 1,
                            novelName: widget.novelName,
                          ),
                        ),
                      );
                    },
                    child: Text('Chương trước'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white, // Set text color to white
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChapterDetailScreen(
                          slug: widget.slug,
                          chapterNo: widget.chapterNo + 1,
                          novelName: widget.novelName,
                        ),
                      ),
                    );
                  },
                  child: Text('Chương sau'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white, // Set text color to white
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}