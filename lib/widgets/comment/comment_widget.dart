import 'dart:convert';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apptruyenonline/models/ProfileModel.dart';
import 'package:apptruyenonline/models/User.dart';
import 'comment.dart';

class CommentWidget extends StatefulWidget {
  final List<Comment> comments;
  final Function(String) onPostComment;
  final Function(String, int) onReply;
  final Function(int) onDelete;
  final TextEditingController commentController;
  final bool showComments;

  const CommentWidget({
    Key? key,
    required this.comments,
    required this.onPostComment,
    required this.onReply,
    required this.onDelete,
    required this.commentController,
    required this.showComments,
  }) : super(key: key);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  Future<Map<String, String>> _getAuthHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<void> _fetchUserImages(Comment comment) async {
    try {
      final response = await http.get(
        Uri.parse('http://14.225.207.58:9898/api/v1/images/?userId=${comment.userId}'),
        headers: await _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        List<dynamic> images = json.decode(utf8.decode(response.bodyBytes));
        if (images.isNotEmpty) {
          setState(() {
            comment.userImage = UserImage(
              id: images[0]['id'] ?? 0,
              type: images[0]['type'] ?? 'image/jpeg',
              data: images[0]['data'],
              createdAt: images[0]['createdAt'] ?? DateTime.now().toIso8601String(),
              user: UserProfile(
                id: comment.userId,
                username: comment.username,
                email: "",
                accountStatus: "",
                point: 0,
                chapterReadCount: 0,
                tierName: "",
              ),
            );
          });
        }
      }
    } catch (e) {
      print('Error fetching user images: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCommentImages();
  }

  Future<void> _initializeCommentImages() async {
    for (var comment in widget.comments) {
      await _fetchUserImages(comment);
      for (var reply in comment.replies) {
        await _fetchUserImages(reply);
      }
    }
  }

  Future<String?> _getCurrentUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  String _formatTimestamp(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  Widget _buildProfileImage(Comment comment) {
    if (comment.userImage?.data != null) {
      try {
        return CircleAvatar(
          radius: 20,
          backgroundImage: MemoryImage(base64Decode(comment.userImage!.data)),
          backgroundColor: Colors.grey[300],
          onBackgroundImageError: (exception, stackTrace) {
            print('Error loading profile image: $exception');
          },
        );
      } catch (e) {
        print('Error decoding image data: $e');
        return _buildDefaultAvatar();
      }
    }
    return _buildDefaultAvatar();
  }

  Widget _buildDefaultAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: AssetImage('assets/avt.png'),
      backgroundColor: Colors.grey[300],
    );
  }

  void _showReplyDialog(BuildContext context, int parentCommentId) {
    final replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.reply, color: Colors.blue),
            SizedBox(width: 8),
            Text('Trả lời bình luận', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: TextField(
          controller: replyController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Nhập trả lời...',
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                widget.onReply(replyController.text.trim(), parentCommentId);
                Navigator.pop(context);
              }
            },
            child: Text('Trả lời'),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, Comment comment) {
    final maxLength = 100;
    final shouldTruncate = comment.content.length > maxLength;
    final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

    return FutureBuilder<String?>(
      future: _getCurrentUsername(),
      builder: (context, snapshot) {
        final currentUsername = snapshot.data;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildProfileImage(comment),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          comment.username,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          _formatTimestamp(comment.createdAt),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        ValueListenableBuilder<bool>(
                          valueListenable: isExpanded,
                          builder: (context, expanded, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expanded ? comment.content :
                                  shouldTruncate ? '${comment.content.substring(0, maxLength)}...' : comment.content,
                                  style: TextStyle(color: Colors.white),
                                ),
                                if (shouldTruncate)
                                  TextButton(
                                    onPressed: () => isExpanded.value = !expanded,
                                    child: Text(
                                      expanded ? 'Thu gọn' : 'Xem thêm',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      if (value == 'reply') {
                        _showReplyDialog(context, comment.id);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, comment.id);
                      }
                    },
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'reply',
                          child: Text('Trả lời'),
                        ),
                        if (comment.username == currentUsername)
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('Xóa', style: TextStyle(color: Colors.red)),
                          ),
                        PopupMenuItem(
                          value: 'report',
                          child: Text('Báo cáo'),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              if (comment.replies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 48.0, top: 8.0),
                  child: Column(
                    children: comment.replies.map((reply) => _buildCommentItem(context, reply)).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
          content: Text('Bạn có chắc chắn muốn xóa bình luận này?', style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              child: Text('Hủy', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
              onPressed: () {
                widget.onDelete(commentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showComments)
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.comments.length,
            itemBuilder: (context, index) => _buildCommentItem(context, widget.comments[index]),
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: widget.commentController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Viết bình luận...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[900],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  if (widget.commentController.text.trim().isNotEmpty) {
                    widget.onPostComment(widget.commentController.text.trim());
                    widget.commentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}