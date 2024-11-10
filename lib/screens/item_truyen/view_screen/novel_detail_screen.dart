import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '../../../models/novel.dart';
import '../../../services/novel_service.dart';
import '../../../widgets/general_widgets/cover_image.dart';
import '../../../widgets/novel_widgets/chapter_list.dart';
import '../../../widgets/novel_widgets/novel_info.dart';
import '../../../widgets/recommendations.dart';
import '../chapter_detail_screen.dart';
import 'mobile_audio_player.dart';

// Thêm extension cho NovelService để xử lý auth headers
extension NovelServiceExtension on NovelService {
  static Future<Map<String, String>> getAuthHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}

class NovelDetailScreen extends StatefulWidget {
  final String slug;

  const NovelDetailScreen({Key? key, required this.slug}) : super(key: key);

  @override
  _NovelDetailScreenState createState() => _NovelDetailScreenState();
}

class _NovelDetailScreenState extends State<NovelDetailScreen> {
  Novel? novel;
  bool _isSaved = false;
  bool _isLiked = false;
  bool _isLoadingLike = false;
  bool _isLoadingRating = false;
  double _userRating = 0.0;
  final TextEditingController _commentController = TextEditingController();
  final Map<int, bool> _showFullComment = {};
  List<dynamic> _comments = [];
  bool _isLoadingComments = false;
  bool _showComments = false; // Thêm vào phần khai báo biến state

  @override
  void initState() {
    super.initState();
    _fetchNovelDetails();
    _checkIfSaved();
    _checkIfLiked();
    _fetchComments();
  }

  Future<void> _fetchNovelDetails() async {
    try {
      final fetchedNovel = await NovelService.fetchNovelDetails(widget.slug);
      if (mounted) {
        setState(() {
          novel = fetchedNovel;
          _userRating = fetchedNovel.averageRatings;
        });
      }
    } catch (e) {
      print('Error in _fetchNovelDetails: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể tải thông tin truyện. Vui lòng thử lại sau.')),
        );
      }
    }
  }

  Future<void> _checkIfSaved() async {
    try {
      bool saved = await NovelService.checkIfSaved(widget.slug);
      if (mounted) {
        setState(() {
          _isSaved = saved;
        });
      }
    } catch (e) {
      print('Error checking if novel is saved: $e');
    }
  }

  Future<void> _checkIfLiked() async {
    if (mounted) {
      setState(() => _isLoadingLike = true);
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      if (userId != null) {
        final response = await http.get(
          Uri.parse('http://14.225.207.58:9898/api/v1/novels/${widget.slug}/is-liked?userId=$userId'),
          headers: await NovelServiceExtension.getAuthHeader(),
        );
        if (mounted) {
          setState(() {
            _isLiked = response.body == 'true';
          });
        }
      }
    } catch (e) {
      print('Error checking like status: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingLike = false);
      }
    }
  }

  Future<void> _toggleLike() async {
    if (mounted) {
      setState(() => _isLoadingLike = true);
    }
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? userId = prefs.getInt('user_id');
      if (userId != null) {
        await http.post(
          Uri.parse('http://14.225.207.58:9898/api/v1/novels/${widget.slug}/like?userId=$userId'),
          headers: await NovelServiceExtension.getAuthHeader(),
        );
        if (mounted) {
          setState(() {
            _isLiked = !_isLiked;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_isLiked ? 'Đã thích truyện' : 'Đã bỏ thích truyện')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLike = false);
      }
    }
  }

  Future<void> _submitRating(double rating) async {
    if (novel == null) return;

    if (mounted) {
      setState(() => _isLoadingRating = true);
    }
    try {
      final novelId = novel!.slug;
      final response = await http.put(
        Uri.parse('http://14.225.207.58:9898/api/v1/rates/set-rate/$novelId'),
        headers: await NovelServiceExtension.getAuthHeader(),
        body: jsonEncode({
          'rate': rating,
          'novelId': novelId
        }),
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _userRating = rating;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đã đánh giá ${rating.toStringAsFixed(1)} sao')),
          );
        }
      } else {
        throw Exception('Failed to submit rating');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể đánh giá. Vui lòng thử lại.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingRating = false);
      }
    }
  }

  Widget _buildCommentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Bình luận',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _isLoadingComments
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return _buildCommentItem(comment);
          },
        ),
      ],
    );
  }

  Widget _buildCommentItem(dynamic comment) {
    final String username = comment['username'] ?? 'Anonymous';
    final String content = comment['content'] ?? '';
    final String createdAt = comment['createdAt'] ?? '';
    final String? userImagePath = comment['user_image_path'];

    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: userImagePath != null
                ? NetworkImage(userImagePath)
                : null,
            backgroundColor: Colors.grey[800],
            child: userImagePath == null
                ? Text(
              username.isNotEmpty ? username[0].toUpperCase() : 'A',
              style: TextStyle(color: Colors.white),
            )
                : null,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  createdAt,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Hàm fetch comments
  Future<void> _fetchComments() async {
    if (mounted) {
      setState(() => _isLoadingComments = true);
    }

    try {
      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/comments/${widget.slug}'),
        headers: await NovelServiceExtension.getAuthHeader(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> commentsData = jsonDecode(utf8.decode(response.bodyBytes));

        if (mounted) {
          setState(() {
            _comments = commentsData;
            _isLoadingComments = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching comments: $e');
      if (mounted) {
        setState(() => _isLoadingComments = false);
      }
    }
  }

  Future<void> _toggleSave() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra. Vui lòng thử lại.')),
      );
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
        title: Text(
          novel?.title ?? 'Chi tiết truyện',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (!_isLoadingLike)
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? Colors.red : Colors.white,
              ),
              onPressed: _toggleLike,
            ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Đánh giá truyện',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    _isLoadingRating
                        ? Center(child: CircularProgressIndicator())
                        : RatingBar.builder(
                      initialRating: _userRating,
                      minRating: 0,
                      maxRating: 5,
                      itemSize: 30,
                      allowHalfRating: true,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: _submitRating,
                    ),
                  ],
                ),
              ),
              ChapterList(
                totalChapters: novel!.totalChapters,
                onChapterTap: _navigateToChapter,
              ),
              // Thêm button và phần hiển thị comments ở đây
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _showComments = !_showComments;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _showComments ? 'Ẩn bình luận' : 'Xem bình luận',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_comments.length}',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Hiển thị comments nếu _showComments = true
              if (_showComments) _buildCommentSection(),
              SizedBox(height: 16),
              Recommendations(),
            ],
          ),
        ),
      ),
    );
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
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
