import 'package:flutter/material.dart';
import 'novel_detail_screen.dart';

class AllItemsScreen extends StatelessWidget {
  final List<dynamic> items;
  final String category;

  const AllItemsScreen({Key? key, required this.items, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: items.isNotEmpty
          ? GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NovelDetailScreen(
                    novelData: item,
                  ),
                ),
              );
            },
            child: ItemCard(
              coverImage: item['coverImage'] ?? 'assets/metruyen.jpg',
              title: item['title'] ?? 'Không có tiêu đề',
              author: item['author'] ?? 'Không có tác giả',
              rating: (item['rating'] as num?)?.toDouble() ?? 0.0,
            ),
          );
        },
      )
          : Center(
        child: Text(
          'Không có dữ liệu để hiển thị',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final String coverImage;
  final String title;
  final String author;
  final double rating;

  const ItemCard({
    Key? key,
    required this.coverImage,
    required this.title,
    required this.author,
    required this.rating,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              coverImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/metruyen.jpg',
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          author,
          style: TextStyle(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: [
            Icon(Icons.star, color: Colors.yellow, size: 16),
            SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}