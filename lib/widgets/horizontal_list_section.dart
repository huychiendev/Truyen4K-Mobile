import 'package:flutter/material.dart';

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

  Widget _buildHorizontalListItem(Map<String, dynamic> item) {
    return Padding(
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
    );
  }
}