import 'package:flutter/material.dart';
import 'comment.dart'; // Import lớp Comment

class CommentWidget extends StatelessWidget {
  final List<Comment> comments;

  const CommentWidget({Key? key, required this.comments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        return _buildCommentItem(context, comment);
      },
    );
  }

  Widget _buildCommentItem(BuildContext context, Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar của người dùng
              CircleAvatar(
                backgroundImage: comment.userImagePath != null
                    ? NetworkImage(comment.userImagePath!)
                    : AssetImage('assets/default_user.png'), // Placeholder cho người dùng không có ảnh
              ),
              SizedBox(width: 8.0),

              // Tên người dùng và nội dung bình luận
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.username,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    // Thời gian bình luận (thời gian định dạng)
                    Text(
                      _formatTimestamp(comment.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      comment.content,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),

              // Nút ba chấm để chọn các hành động
              PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'reply') {
                    _showReplyDialog(context, comment.id);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: 'reply',
                      child: Text('Trả lời'),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: Text('Chỉnh sửa'),
                    ),
                    PopupMenuItem(
                      value: 'report',
                      child: Text('Báo cáo'),
                    ),
                  ];
                },
                icon: Icon(Icons.more_vert, color: Colors.black),
              ),
            ],
          ),

          // Hiển thị các bình luận trả lời (nếu có)
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
  }

  // Hàm để hiển thị hộp thoại trả lời bình luận
  void _showReplyDialog(BuildContext context, int parentCommentId) {
    final TextEditingController _replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Trả lời bình luận'),
          content: TextField(
            controller: _replyController,
            decoration: InputDecoration(hintText: 'Nhập trả lời...'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (_replyController.text.trim().isNotEmpty) {
                  // Logic xử lý đăng trả lời bình luận
                  Navigator.pop(context);
                }
              },
              child: Text('Trả lời'),
            ),
          ],
        );
      },
    );
  }

  // Di chuyển hàm _formatTimestamp vào trong lớp CommentWidget
  String _formatTimestamp(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'vừa xong';
    }
  }
}
