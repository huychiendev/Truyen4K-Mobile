// lib/widgets/novel_widgets/comment_widgets.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/comment.dart';
import '../../services/novel_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Button Bình luận hiển thị ở màn hình chính
class CommentButton extends StatelessWidget {
  final int commentCount;
  final double rating;
  final VoidCallback onPressed;

  const CommentButton({
    Key? key,
    required this.commentCount,
    required this.rating,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        border: Border(
          top: BorderSide(color: Colors.grey[800]!, width: 1),
          bottom: BorderSide(color: Colors.grey[800]!, width: 1),
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Icon(Icons.chat_bubble_outline, color: Colors.white70, size: 20),
            SizedBox(width: 8),
            Text(
              'Bình luận',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Spacer(),
            if (rating > 0) ...[
              Icon(Icons.star, color: Colors.amber, size: 16),
              SizedBox(width: 4),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                ' | ',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
            Text(
              '${(commentCount/1000).toStringAsFixed(1)}K',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Icon(Icons.chevron_right, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }
}

// Bottom sheet hiển thị khi click vào button bình luận
class CommentBottomSheet extends StatelessWidget {
  final List<Comment> comments;
  final bool isLoading;
  final TextEditingController commentController;
  final Function(int) onToggleShowFull;
  final Map<int, bool> showFullComment;
  final VoidCallback onSubmitComment;
  final String Function(String) shortenComment;
  final VoidCallback? onRefreshComments;

  const CommentBottomSheet({
    Key? key,
    required this.comments,
    required this.isLoading,
    required this.commentController,
    required this.onToggleShowFull,
    required this.showFullComment,
    required this.onSubmitComment,
    required this.shortenComment,
    this.onRefreshComments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bình luận',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[800], height: 1),

          // Comments List
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) => _buildCommentItem(context, index),
            ),
          ),

          // Comment Input
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, int index) {
    final comment = comments[index];
    final showFull = showFullComment[index] ?? false;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Row
          Row(
            children: [
              // Avatar
              CircleAvatar(
                backgroundImage: comment.userImageData != null
                    ? MemoryImage(base64Decode(comment.userImageData!))
                    : null,
                child: comment.userImageData == null
                    ? Icon(Icons.person, color: Colors.white)
                    : null,
                backgroundColor: Colors.grey[800],
              ),
              SizedBox(width: 12),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (comment.tierName != null) ...[
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              comment.tierName!,
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      comment.createdAt,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              // Menu Button (3 chấm)
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white70),
                onPressed: () => _showCommentOptions(context, comment),
              ),
            ],
          ),

          // Comment Content
          SizedBox(height: 8),
          GestureDetector(
            onTap: () => onToggleShowFull(index),
            child: Text(
              showFull ? comment.content : shortenComment(comment.content),
              style: TextStyle(color: Colors.white70),
            ),
          ),

          // Bottom Border
          SizedBox(height: 16),
          Divider(color: Colors.grey[800], height: 1),
        ],
      ),
    );
  }

  Future<void> _showCommentOptions(BuildContext context, Comment comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentUserId = prefs.getInt('user_id');
    final isCommentAuthor = currentUserId != null && comment.userId == currentUserId;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => Container(
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: Icon(Icons.thumb_up_outlined, color: Colors.white),
                title: Text('Thích', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(ctx);
                },
              ),
              if (isCommentAuthor)
                ListTile(
                  leading: Icon(Icons.delete_outline, color: Colors.red),
                  title: Text('Xóa', style: TextStyle(color: Colors.red)),
                  onTap: () async {
                    try {
                      await NovelService.deleteComment(comment.id);
                      Navigator.pop(ctx);
                      if (onRefreshComments != null) {
                        onRefreshComments!();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã xóa bình luận')),
                      );
                    } catch (e) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không thể xóa bình luận. Vui lòng thử lại.')),
                      );
                    }
                  },
                ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Để lại bình luận...',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.grey[850],
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blueAccent),
            onPressed: onSubmitComment,
          ),
        ],
      ),
    );
  }
}