import 'package:flutter/material.dart';
import 'comment.dart'; // Import lớp Comment từ comment.dart

class CommentWidget extends StatelessWidget {
  final List<Comment> comments;

  const CommentWidget({
    Key? key,
    required this.comments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lọc ra các comment cha (không có parentId)
    final parentComments = comments.where((c) => c.parentId == null).toList();

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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: parentComments.length,
          itemBuilder: (context, index) {
            final parentComment = parentComments[index];
            // Lấy các comment con của comment cha này
            final childComments = comments
                .where((c) => c.parentId == parentComment.id)
                .toList();

            return Column(
              children: [
                _buildCommentItem(parentComment),
                if (childComments.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(left: 40), // Thụt lề cho comment con
                    child: Column(
                      children: childComments.map((child) => _buildCommentItem(child)).toList(),
                    ),
                  ),
                SizedBox(height: 8), // Khoảng cách giữa các nhóm comment
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: comment.userImagePath != null
                ? NetworkImage(comment.userImagePath!)
                : null,
            backgroundColor: Colors.grey[800],
            child: comment.userImagePath == null
                ? Text(
              comment.username.isNotEmpty
                  ? comment.username[0].toUpperCase()
                  : 'A',
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
                  comment.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  comment.content,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  _formatTimestamp(comment.createdAt),
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