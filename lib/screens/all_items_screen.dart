import 'package:flutter/material.dart';

class AllItemsScreen extends StatelessWidget {
  final List<dynamic> items;
  final String category;

  const AllItemsScreen({Key? key, required this.items, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: items.isNotEmpty
          ? GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index] as Map<String, dynamic>;

          // Check if required fields are available
          final coverImage = item['coverImage'] ?? 'assets/placeholder.jpg';
          final title = item['title'] ?? 'Không có tiêu đề';
          final author = item['author'] ?? 'Không có tác giả';
          final rating = item['rating']?.toDouble() ?? 0.0;

          return ItemCard(
            coverImage: coverImage,
            title: title,
            author: author,
            rating: rating,
          );
        },
      )
          : Center(
        child: Text('Không có dữ liệu để hiển thị'),
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
            child: Image.asset(
              coverImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(author),
        Row(
          children: [
            Icon(Icons.star, color: Colors.yellow, size: 16),
            SizedBox(width: 4),
            Text(rating.toString()),
          ],
        ),
      ],
    );
  }
}
