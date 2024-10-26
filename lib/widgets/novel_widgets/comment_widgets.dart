// lib/widgets/novel_widgets/comment_widgets.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/comment.dart';

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

  const CommentBottomSheet({
    Key? key,
    required this.comments,
    required this.isLoading,
    required this.commentController,
    required this.onToggleShowFull,
    required this.showFullComment,
    required this.onSubmitComment,
    required this.shortenComment,
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
              itemBuilder: (context, index) => _buildCommentItem(index),
            ),
          ),

          // Comment Input
          _buildCommentInput(context),
        ],
      ),
    );
  }

  Widget _buildCommentItem(int index) {
    final comment = comments[index];
    final showFull = showFullComment[index] ?? false;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info
          Row(
            children: [
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
                  ],
                ),
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
          Divider(color: Colors.grey[800], height: 32),
        ],
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