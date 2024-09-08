import 'package:flutter/material.dart';
import '../screens/all_items_screen.dart';
import '../screens/novel_detail_screen.dart'; // Đảm bảo đường dẫn đúng

class HorizontalListSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final String category; // Thêm tham số category

  const HorizontalListSection({
    Key? key,
    required this.title,
    required this.items,
    required this.category, // Đảm bảo category được truyền từ màn hình cha
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
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  // Điều hướng tới màn hình "Xem Tất Cả" và truyền cả items lẫn category
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllItemsScreen(
                        items: items,
                        category: category, // Truyền danh mục
                      ),
                    ),
                  );
                },
                child: Text(
                  'Xem Tất Cả',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items
                  .map((item) => _buildHorizontalListItem(
                  context, item as Map<String, dynamic>))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListItem(
      BuildContext context, Map<String, dynamic> item) {
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
            Text(item['title'] ?? 'Title', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // Hàm hiển thị Snackbar
  void _showSnackbar(BuildContext context, String title, String subtitle) {
    final snackBar = SnackBar(
      content: Text('Title: $title\nSubtitle: $subtitle'),
      duration: Duration(seconds: 3), // Tự động biến mất sau 3 giây
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