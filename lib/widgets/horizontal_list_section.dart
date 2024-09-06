import 'package:flutter/material.dart';
import '../screens/novel_detail_screen.dart';

class HorizontalListSection extends StatelessWidget {
  final String title;
  final String actionText;
  final List<dynamic> items;

  const HorizontalListSection({
    Key? key,
    required this.title,
    required this.actionText,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(actionText, style: TextStyle(color: Colors.green)),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items.map((item) => _buildHorizontalListItem(context, item as Map<String, dynamic>)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Cập nhật hàm này để thêm GestureDetector và hiển thị Snackbar
  Widget _buildHorizontalListItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Hiển thị thông báo SnackBar và tự động biến mất sau 3 giây
        _showSnackbar(context, item['title'], item['subtitle']);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 8),
            Text(
              item['title'] as String? ?? '',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              item['subtitle'] as String? ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị Snackbar
  void _showSnackbar(BuildContext context, String title, String subtitle) {
    final snackBar = SnackBar(
      content: Text('Title: $title\nSubtitle: $subtitle'),
      duration: Duration(seconds: 3),  // Tự động biến mất sau 3 giây
    );

    // Hiển thị SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Sau khi hiển thị SnackBar, chuyển sang màn hình chi tiết sau 3 giây
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NovelDetailScreen(
            title: title,
            subtitle: subtitle,
          ),
        ),
      );
    });
  }
}
