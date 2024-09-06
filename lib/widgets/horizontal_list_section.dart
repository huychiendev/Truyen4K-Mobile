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
              children: items.map((item) => _buildHorizontalListItem(item as Map<String, dynamic>)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalListItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NovelDetailScreen(
              title: item['title'],
              subtitle: item['subtitle'],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Your existing widgets, such as images, titles, etc.
            Text(
              item['title'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              item['subtitle'],
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

}