import 'package:flutter/material.dart';
import '../../models/novel.dart';
import 'package:apptruyenonline/screens/author/author_detail_screen.dart';  // Import màn hình chi tiết tác giả

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
          // Tiêu đề của tiểu thuyết
          Text(
            novel.title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),

          // Tên tác giả có thể click để dẫn đến màn hình chi tiết tác giả
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthorDetailScreen(
                    authorName: novel.authorName,
                    authorId: novel.authorId, // Truyền authorId
                  ),
                ),
              );
            },
            child: Text(
              'Tác giả: ${novel.authorName.isNotEmpty ? novel.authorName : 'Chưa có thông tin tác giả'}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,  // Đổi màu để thể hiện có thể click
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          // Số chương của tiểu thuyết
          Text(
            '${novel.totalChapters} Chương',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 8),

          // Hàng thống kê (Số lượt đọc, đánh giá trung bình, số lượt thích)
          _buildStatsRow(),
          SizedBox(height: 16),

          // Mô tả về cuốn truyện
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

          // Thể loại (tags)
          _buildTags(),
        ],
      ),
    );
  }

  // Phương thức hiển thị các thống kê như số lượt đọc, đánh giá, và lượt thích
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

  // Phương thức hiển thị thể loại (tags)
  Widget _buildTags() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: novel.genreNames.map((tag) => _buildTag(tag)).toList(),
    );
  }

  // Phương thức hiển thị một tag thể loại
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
