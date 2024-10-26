import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/comment.dart';
import '../../../models/novel.dart';
import '../../../services/novel_service.dart';
import '../../../widgets/general_widgets/cover_image.dart';
import '../../../widgets/novel_widgets/chapter_list.dart';
import '../../../widgets/novel_widgets/novel_info.dart';
import '../../../widgets/recommendations.dart';
import '../../../widgets/novel_widgets/comment_widgets.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải thông tin truyện. Vui lòng thử lại sau.')),
      );
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int? userId = prefs.getInt('user_id');

        if (userId != null) {
          await NovelService.submitComment(widget.slug, content, userId);
          _commentController.clear();
          _fetchComments();
          Navigator.of(context).pop(); // Close bottom sheet after successful comment
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Bình luận đã được đăng')),
          );
        } else {
          throw Exception('User ID not found');
        }
      } catch (e) {
        print('Error submitting comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
        );
      }
    }
  }

  void _showCommentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => CommentBottomSheet(
          comments: comments,
          isLoading: _isLoadingComments,
          commentController: _commentController,
          onToggleShowFull: (index) {
            setState(() {
              _showFullComment[index] = !(_showFullComment[index] ?? false);
            });
          },
          showFullComment: _showFullComment,
          onSubmitComment: _submitComment,
          shortenComment: _shortenComment,
          onRefreshComments: _fetchComments, // Thêm callback này
        ),
      ),
    );
  }

  String _shortenComment(String content) {
    const int maxLength = 100;
    if (content.length > maxLength) {
      return content.substring(0, maxLength) + '... Xem thêm';
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
          content: Text(_isSaved ? 'Đã lưu truyện!' : 'Đã xóa khỏi danh sách lưu!'),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          novel?.title ?? 'Chi tiết truyện',
          style: TextStyle(color: Colors.white),
        ),
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
          : RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            _fetchNovelDetails(),
            _fetchComments(),
          ]);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              CoverImage(
                imageUrl: novel!.thumbnailImageUrl,
                onReadPressed: () => _navigateToChapter(1),
                onListenPressed: () => _navigateToAudioPlayer(1),
              ),
              NovelInfo(novel: novel!),
              CommentButton(
                commentCount: comments.length,
                rating: novel?.averageRatings ?? 0.0,
                onPressed: _showCommentBottomSheet,
              ),
              ChapterList(
                totalChapters: novel!.totalChapters,
                onChapterTap: _navigateToChapter,
              ),
              Recommendations(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}