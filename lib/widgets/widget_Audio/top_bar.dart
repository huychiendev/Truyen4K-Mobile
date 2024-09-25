import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onMinimizePlayer;
  final bool isLiked;
  final bool isSaved;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleSave;

  const TopBar({
    Key? key,
    required this.onMinimizePlayer,
    required this.isLiked,
    required this.isSaved,
    required this.onToggleLike,
    required this.onToggleSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24),
          onPressed: onMinimizePlayer,
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Colors.white, size: 24),
          onSelected: (String result) {
            if (result == 'like') {
              onToggleLike();
            } else if (result == 'save') {
              onToggleSave();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'like',
              child: Row(
                children: [
                  Icon(isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked ? Colors.red : null),
                  const SizedBox(width: 8),
                  Text(isLiked ? 'Unlike' : 'Like'),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'save',
              child: Row(
                children: [
                  Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                  const SizedBox(width: 8),
                  Text(isSaved ? 'Unsave' : 'Save'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}