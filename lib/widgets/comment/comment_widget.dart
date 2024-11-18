import 'package:flutter/material.dart';
import 'comment.dart';

class CommentWidget extends StatelessWidget {
  final List<Comment> comments;
  final Function(String, int) onReply;
  final TextEditingController commentController;
  final Function(String) onPostComment;
  final bool showComments;

  const CommentWidget({
    Key? key,
    required this.comments,
    required this.onReply,
    required this.commentController,
    required this.onPostComment,
    required this.showComments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (showComments) _buildComments(),
        _buildCommentInput(),
      ],
    );
  }

  Widget _buildComments() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) => _buildCommentItem(context, comments[index]),
    );
  }

  Widget _buildCommentItem(BuildContext context, Comment comment) {
    final maxLength = 100;
    final shouldTruncate = comment.content.length > maxLength;
    final ValueNotifier<bool> isExpanded = ValueNotifier<bool>(false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: comment.userImagePath != null
                    ? NetworkImage(comment.userImagePath!)
                    : AssetImage('assets/default_user.png') as ImageProvider,
                radius: 20,
              ),
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
                  }
                },
                icon: Icon(Icons.more_vert, color: Colors.white),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: 'reply',
                    child: Text('Trả lời'),
                  ),
                  PopupMenuItem(
                    value: 'report',
                    child: Text('Báo cáo'),
                  ),
                ],
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
  }

  Widget _buildCommentInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
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
              if (commentController.text.trim().isNotEmpty) {
                onPostComment(commentController.text.trim());
                commentController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, int parentCommentId) {
    final replyController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Trả lời bình luận'),
        content: TextField(
          controller: replyController,
          decoration: InputDecoration(hintText: 'Nhập trả lời...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              if (replyController.text.trim().isNotEmpty) {
                onReply(replyController.text.trim(), parentCommentId);
                Navigator.pop(context);
              }
            },
            child: Text('Trả lời'),
          ),
        ],
      ),
    );
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
}