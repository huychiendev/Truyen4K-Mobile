import 'package:flutter/material.dart';

class AuthorDetailScreen extends StatefulWidget {
  final String authorName;
  final int authorId;

  const AuthorDetailScreen({
    Key? key,
    required this.authorName,
    required this.authorId,
  }) : super(key: key);

  @override
  _AuthorDetailScreenState createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Thông tin tác giả'),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {}, // Placeholder for follow function
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAuthorInfo(),
            _buildStats(),
            _buildNovelsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorInfo() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.authorName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tác giả',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Tác phẩm', 5), // Sample data
          _buildStatItem('Người theo dõi', 100), // Sample data
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildNovelsList() {
    // Sample novel data với kiểu dữ liệu rõ ràng
    final List<Map<String, dynamic>> sampleNovels = List.generate(5, (index) => {
      'title': 'Tên truyện ${index + 1}',
      'thumbnailUrl': 'https://via.placeholder.com/60x90',
      'totalChapters': 100 + index,
      'readCount': 1000 + (index * 100),
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sampleNovels.length,
      itemBuilder: (context, index) {
        final Map<String, dynamic> novel = sampleNovels[index];
        return Card(
          color: Colors.grey[900],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                novel['thumbnailUrl'] as String, // Chỉ định kiểu String
                width: 60,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 90,
                  color: Colors.grey[800],
                  child: Icon(Icons.book, color: Colors.grey),
                ),
              ),
            ),
            title: Text(
              novel['title'] as String, // Chỉ định kiểu String
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Số chương: ${novel['totalChapters']}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  'Lượt đọc: ${novel['readCount']}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            onTap: () {
              // Placeholder for navigation to novel detail
            },
          ),
        );
      },
    );
  }
}