import 'package:flutter/material.dart';

import '../../../models/novel.dart';
import '../../../services/novel_service.dart';
import '../../../widgets/chapter_list.dart';
import '../../../widgets/cover_image.dart';
import '../../../widgets/novel_info.dart';
import '../../../widgets/recommendations.dart';
import '../chapter_detail_screen.dart';
import 'mobile_audio_player.dart';


class NovelDetailScreen extends StatefulWidget {
  final String slug;

  const NovelDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  _NovelDetailScreenState createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  Novel? novel;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _fetchNovelDetails();
    _checkIfSaved();
  }

  Future<void> _fetchNovelDetails() async {
    try {
      final fetchedNovel = await NovelService.fetchNovelDetails(widget.slug);
      setState(() {
        novel = fetchedNovel;
      });
    } catch (e) {
      print('Error fetching novel details: $e');
      // Handle error (e.g., show error message to user)
    }
  }

  Future<void> _checkIfSaved() async {
    try {
      bool saved = await NovelService.checkIfSaved(widget.slug);
      setState(() {
        _isSaved = saved;
      });
    } catch (e) {
      print('Error checking if novel is saved: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(novel?.title ?? 'Novel Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? Colors.green : Colors.white,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: novel == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            CoverImage(
              imageUrl: novel!.thumbnailImageUrl,
              onReadPressed: () => _navigateToChapter(1),
              onListenPressed: () => _navigateToAudioPlayer(1),
            ),
            NovelInfo(novel: novel!),
            ChapterList(
              totalChapters: novel!.totalChapters,
              onChapterTap: _navigateToChapter,
            ),
            Recommendations(),
          ],
        ),
      ),
    );
  }

  void _toggleSave() async {
    try {
      bool newSavedState = await NovelService.toggleSave(widget.slug);
      setState(() {
        _isSaved = newSavedState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isSaved ? 'Đã lưu truyện!' : 'Đã xóa khỏi danh sách lưu!')),
      );
    } catch (e) {
      print('Error toggling save state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
      );
    }
  }

  void _navigateToChapter(int chapterNo) {
    // Navigation logic for reading a chapter
    // Example:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterDetailScreen(
          slug: widget.slug,
          chapterNo: chapterNo,
          novelName: novel!.title,
        ),
      ),
    );
  }

  void _navigateToAudioPlayer(int chapterNo) {
    // Navigation logic for audio player
    // Example:
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MobileAudioPlayer(
          slug: widget.slug,
          chapterNo: chapterNo,
          novelName: novel!.title,
          thumbnailImageUrl: novel!.thumbnailImageUrl,
        ),
      ),
    );
  }
}