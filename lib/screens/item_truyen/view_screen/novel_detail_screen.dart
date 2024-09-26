import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/comment.dart';
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
  bool _isLoadingComments = false;
  List<Comment> comments = [];
  final TextEditingController _commentController = TextEditingController();
  final Map<int, bool> _showFullComment = {};

  @override
  void initState() {
    super.initState();
    _fetchNovelDetails();
    _checkIfSaved();
    _fetchComments();
  }


  Future<void> _fetchComments() async {
    setState(() {
      _isLoadingComments = true;
    });
    try {
      final fetchedComments = await NovelService.fetchComments(widget.slug);
      setState(() {
        comments = fetchedComments;
        _showFullComment.clear();
      });
    } catch (e) {
      print('Error fetching comments: $e');
      // Handle error (e.g., show error message to user)
    } finally {
      setState(() {
        _isLoadingComments = false;
      });
    }
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

  Future<void> _submitComment() async {
    String content = _commentController.text;
    if (content.isNotEmpty) {
      try {
        await NovelService.submitComment(widget.slug, content);
        _commentController.clear();
        _fetchComments();
      } catch (e) {
        print('Error submitting comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
        );
      }
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
        title: Text(novel?.title ?? 'Novel Details',
            style: TextStyle(color: Colors.white)),
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
                  _buildCommentsSection(),
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

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Text(
            'Comments',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_isLoadingComments)
          Center(child: CircularProgressIndicator())
        else
          ...comments.asMap().entries.map((entry) {
            int index = entry.key;
            Comment comment = entry.value;
            bool showFull = _showFullComment[index] ?? false;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: comment.userImageData != null
                      ? MemoryImage(base64Decode(comment.userImageData!))
                      : null,
                  child: comment.userImageData == null
                      ? Icon(Icons.person, color: Colors.white)
                      : null,
                  backgroundColor: Colors.grey[800],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (comment.tierName != null)
                      Text(
                        '${comment.tierName}',
                        style: TextStyle(color: Colors.orange),
                      ),
                  ],
                ),
                subtitle: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showFullComment[index] = !showFull;
                    });
                  },
                  child: Text(
                    showFull ? comment.content : _shortenComment(comment.content),
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            );
          }).toList(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: InputDecoration(
                    hintText: 'Để lại bình luận...',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.grey[850],
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blueAccent),
                onPressed: _submitComment,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _shortenComment(String content) {
    const int maxLength = 100;
    if (content.length > maxLength) {
      return content.substring(0, maxLength) + '... Read more';
    }
    return content;
  }

  void _toggleSave() async {
    try {
      bool newSavedState = await NovelService.toggleSave(widget.slug);
      setState(() {
        _isSaved = newSavedState;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                _isSaved ? 'Đã lưu truyện!' : 'Đã xóa khỏi danh sách lưu!')),
      );
    } catch (e) {
      print('Error toggling save state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
      );
    }
  }

  void _navigateToChapter(int chapterNo) {
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
