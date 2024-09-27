import 'package:flutter/material.dart';

class CoverImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onReadPressed;
  final VoidCallback onListenPressed;

  const CoverImage({
    Key? key,
    required this.imageUrl,
    required this.onReadPressed,
    required this.onListenPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          imageUrl,
          height: 500,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 500,
              color: Colors.grey,
              child: Center(child: Text('Hình ảnh không khả dụng', style: TextStyle(color: Colors.white))),
            );
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.black.withOpacity(0.7),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.book, color: Colors.white),
                    label: Text('Đọc Truyện', style: TextStyle(color: Colors.white)),
                    onPressed: onReadPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF232538),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.headphones, color: Colors.white),
                    label: Text('Nghe Truyện', style: TextStyle(color: Colors.white)),
                    onPressed: onListenPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF232538),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}