import 'package:flutter/material.dart';
import '../screens/item_truyen/all_items_screen.dart';

class HorizontalListSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final String category;
  final Function(Map<String, dynamic>) onPlayTap;

  const HorizontalListSection({
    Key? key,
    required this.title,
    required this.items,
    required this.category,
    required this.onPlayTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllItemsScreen(
                        items: items,
                        category: category,
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
                  .map((item) => _buildHorizontalListItem(context, item))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildHorizontalListItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        print('Bạn đã nhấn vào ${item['title'] ?? 'Không có tiêu đề'}');
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item['thumbnailImageUrl'] ?? r'D:\Android Studio\apptruyenonline\assets\300.jpg',
                    width: 120,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Error loading image: $error');
                      return Container(
                        width: 120,
                        height: 140,
                        color: Colors.grey[800],
                        child: Icon(Icons.image_not_supported, color: Colors.white70),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: IconButton(
                    icon: Icon(Icons.play_circle_filled, color: Colors.white),
                    onPressed: () {
                      if (item != null) {
                        onPlayTap(item);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              width: 120,
              child: Text(
                item['title'] ?? 'Không có tiêu đề',
                style: TextStyle(fontSize: 14, color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}