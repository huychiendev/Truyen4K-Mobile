import 'package:flutter/material.dart';
import '../screens/item_truyen/all_items_screen.dart';

class HorizontalListSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final String category;

  const HorizontalListSection({
    Key? key,
    required this.title,
    required this.items,
    required this.category,
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
              children: items.map((item) => _buildHorizontalListItem(context, item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        print('Bạn đã nhấn vào ${item['title']}');
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
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(item['thumbnailImageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: 120,
              child: Text(
                item['title'] ?? 'Title',
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
