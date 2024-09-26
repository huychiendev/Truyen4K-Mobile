import 'package:flutter/material.dart';
import '../models/novel.dart';

class NovelInfo extends StatelessWidget {
  final Novel novel;

  const NovelInfo({Key? key, required this.novel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            novel.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Tác giả: ${novel.authorName}',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            '${novel.totalChapters} Chương',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 8),
          _buildStatsRow(),
          SizedBox(height: 16),
          Text(
            'Về cuốn truyện này',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            novel.description,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 16),
          _buildTags(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(novel.readCounts.toString(), style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.star, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text(novel.averageRatings.toStringAsFixed(1), style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        Icon(Icons.thumb_up, size: 16, color: Colors.grey),
        SizedBox(width: 4),
        Text('${novel.likeCounts}K', style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: novel.genreNames.map((tag) => _buildTag(tag)).toList(),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(tag, style: TextStyle(color: Colors.white)),
    );
  }
}