import 'package:apptruyenonline/screens/item_truyen/view_screen/mobile_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../chapter_detail_screen.dart';
import 'miniplayer.dart'; // Import MiniPlayer

class NovelDetailScreen extends StatefulWidget {
  final String slug;

  const NovelDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  _NovelDetailScreenState createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  bool _showMiniPlayer = false;
  String? currentChapter;
  String? currentNovelName;
  bool _isPlaying = false;
  double _progress = 0.0;
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
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {
          'showMiniPlayer': _showMiniPlayer,
          'currentChapter': currentChapter,
          'currentNovelName': currentNovelName,
          'isPlaying': _isPlaying,
          'progress': _progress,
        });
        return false;
      },
      child: novelData == null
          ? Center(child: CircularProgressIndicator())
          : Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Text(
            novelData!['title'] ?? 'Novel Details',
            style: TextStyle(color: Colors.white),
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.bookmark_border, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Truyện chưa được note lại đâu nhá !')),
                            );
                          },
                        ),
                      ],
                    ),
                    Text(
                        'Tác giả: ' + (novelData!['authorName'] ?? 'Unknown Author'),
                        style: TextStyle(fontSize: 16, color: Colors.white70)
                    ),
                    Text(
                        '${novelData!['totalChapters'] ?? 'Unknown'} Chương',
                        style: TextStyle(color: Colors.grey)
                    ),
                    SizedBox(height: 8),
                    _buildStatsRow(
                        novelData!['readCounts']?.toString() ?? 'Unknown',
                        (novelData!['averageRatings'] as num?)?.toDouble() ?? 0.0,
                        (novelData!['likeCounts'] as num?)?.toInt() ?? 0
                    ),
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
                    _buildTags(novelData!['genreNames'].toSet().toList()),
                  ],
                ),
              ),

              // Thêm danh sách chương ở đây nếu cần
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemCount: novelData!['totalChapters'] ?? 0,
              //   itemBuilder: (context, index) {
              //     return ListTile(
              //       title: Text('Chapter ${index + 1}', style: TextStyle(color: Colors.white)),
              //       trailing: Icon(Icons.play_arrow, color: Colors.white),
              //       onTap: () {
              //         // Xử lý khi nhấn vào chương
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
        bottomNavigationBar: _showMiniPlayer ? _buildMiniPlayer() : null,
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
              child: Center(
                  child: Text('Hình ảnh không khả dụng',
                      style: TextStyle(color: Colors.white))),
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
                    label: Text('Nghe tiếp', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MobileAudioPlayer(
                            slug: widget.slug,
                            chapterNo: currentChapter != null ? int.parse(currentChapter!) : 1,
                            novelName: novelData!['title'] ?? 'Tiêu đề không xác định',
                            thumbnailImageUrl: novelData!['thumbnailImageUrl'] ?? '',
                          ),
                        ),
                      );
                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          _showMiniPlayer = result['showMiniPlayer'] ?? false;
                          currentChapter = result['currentChapter'];
                          currentNovelName = result['currentNovelName'];
                          _isPlaying = result['isPlaying'] ?? false;
                          _progress = result['progress'] ?? 0.0;
                        });
                      }
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

  Widget _buildMiniPlayer() {
    return MiniPlayer(
      title: currentNovelName ?? '',
      artist: 'Chương ${currentChapter ?? ''}',
      imageUrl: novelData?['thumbnailImageUrl'] ?? 'https://example.com/novel_thumbnail.jpg',
      isPlaying: _isPlaying,
      onTap: () {
        // Xử lý khi nhấn vào MiniPlayer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MobileAudioPlayer(
              slug: widget.slug,
              chapterNo: currentChapter != null ? int.parse(currentChapter!) : 1,
              novelName: currentNovelName ?? '',
              thumbnailImageUrl: novelData?['thumbnailImageUrl'] ?? '',
            ),
          ),
        ).then((result) {
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              _showMiniPlayer = result['showMiniPlayer'] ?? false;
              currentChapter = result['currentChapter'];
              currentNovelName = result['currentNovelName'];
              _isPlaying = result['isPlaying'] ?? false;
              _progress = result['progress'] ?? 0.0;
            });
          }
        });
      },
      onPlayPause: () {
        setState(() {
          _isPlaying = !_isPlaying; // Chuyển đổi trạng thái play/pause
        });
      },
      onNext: () {
        // Xử lý chức năng chuyển sang chương tiếp theo
      },
      onDismiss: () {
        setState(() {
          _showMiniPlayer = false;
        });
      },
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
